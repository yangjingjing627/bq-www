<storage-in>
	<div class="storage-in">
		<div class="storage-top">
			<div class="search">
				<search opts={ searchOpts }></search>
			</div>
			<div class="supplier">
				<div class="business">供货商:</div>
				<div class="select" onclick={ supplier }>
					<span id="selectSupplierName">无</span>
					<input type="hidden" id="selectSupplierId"/>
					<div class="icon-down"></div>
					<div class="drop-down display-none">
						<span each={ supplierList } onclick={ selectSupplier }>{ supplierName }</span>
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</div>
		<div class="storage-content">
			<div class="storage-product">
				<div class="product-li" if={ goods.length>0 }>
					<ul>
						<li each={ goods } onclick={ forDetail } class={ active:active }>
							<div class="img"><img alt="" src="{ imageUrl  || 'imgs/default-product.png'}">
							</div>
							<div class="info">
								<h3>{ goodsName }</h3>
								<h2>￥{ purchasePrice }</h2>
							</div>
							<div class="add-less">
								<div class="less" onclick={ decrGoods }></div>
								<div class="input">{ quantity }</div>
								<div class="add" onclick={ incrGoods }></div>
								<div class="clear"></div>
							</div>
							<div class="total">小计：￥{ subtotal }</div>
						</li>
					</ul>
				</div>
				<div class="billing pro-li" if={ goods.length>0 }>
					<ul>
						<li>品类：{ categoryNum }</li>
						<li>总数：{ quantity }</li>
						<li>合计进价：<i>￥{ goodsAmount }</i>
						</li>
					</ul>
				</div>
			</div>
			<div class="storage-detail">
				<div class="s-pro-d" style="display: none">
					<div class="img"><img alt="" src="{ detail.imageUrl  || 'imgs/default-product.png'}">
					</div>
					<div class="name">{ detail.goodsName }</div>
					<div class="billing">
						<ul>
							<li>进价：<i>￥{detail.purchasePrice }</i>
							</li>
							<li>库存：{ detail.quantity }</li>
						</ul>
					</div>
				</div>
				<div class="st-button">
					<a class={ disable: !quantity } onclick={ commit }>
						<i if={ type==1 }>生成入库单</i>
						<i if={ type==2 }>生成出库单</i>
					</a>
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<modal id="storage-warning" modal-width="200px" modal-height="80px" nofooter>
			<p class="warning-text">{ parent.warningText }</p>
		</modal>
		<modal id="storage-warning-han" modal-width="430px" modal-height="80px" nofooter>
			<p class="warning-text">{ parent.warningText1 }</p>
		</modal>
		<modal id="storageAddPurchasePrice" modal-width="" modal-height="">
			<add-price></add-price>
		</modal>
	</div>
	<script>
		var self = this;
		var params = riot.routeParams.params;
		var type = params.type;
		self.type = type;
		selectSupplier(e) {
			$("#selectSupplierName").text(e.item.supplierName);
			$("#selectSupplierId").val(e.item.supplierId);
		}

		self.scanCodeStorage = function () {
			var number = Icommon.number;
			httpGet({
				url: api.gooduuidByBarcode,
				params: {
					barcode: number
				},
				success: function (res) {
					if (res && res.data && res.data.goodsUuid) {
						self.goodsAdd(res.data);
					} else {
						warningHan("商品未建档，请先在“店铺”-“商品”处添加该商品");
					}
				}
			});
		}

		function warning(text) {
			var layer = $('#storage-warning')[0];

			self.warningText = text;
			self.update();

			layer.open();
			setTimeout(function () {
				layer.close();
			}, 1000);
		}

		function warningHan(text) {
			var layer = $('#storage-warning-han')[0];

			self.warningText1 = text;
			self.update();

			layer.open();
			setTimeout(function () {
				layer.close();
			}, 2000);
		}

		commit(e) {
			if (!self.quantity) {
				return;
			} else {
				var param = {
					type: type
				};
				param.supplierId = $("#selectSupplierId").val();
				store.stockCommit.get(param, function (data) {
					//toast 提示
					if (type == 1) {
						warning('入库单已生成');
					} else {
						warning('出库单已生成');
					}
					self.goods = [];
					self.detail = "";
					self.goodsAmount = '';
					self.quantity = '';
					self.categoryNum = '';
					$(".s-pro-d").hide();
					self.update();
					store.synTask.get({
						name: "Goods"
					}, function () {});
				});
			}
		}

		supplier(e) {
			$(".drop-down").toggleClass("display-none");
		}

		incrGoods(e) { // 增加数量
			var param = {
				goodsUuid: e.item.goodsUuid,
				type: type
			};
			store.stockIncr.get(param, function (data) {
				self.goodsAmount = data.goodsAmount;
				self.quantity = data.quantity;
				self.categoryNum = data.categoryNum;
				e.item.quantity = data.qty;
				e.item.subtotal = (e.item.quantity * e.item.purchasePrice).toFixed(2);
				self.update();
			});
		}

		decrGoods(e) { //减少数量
			var param = {
				goodsUuid: e.item.goodsUuid,
				type: type
			};
			store.stockDecr.get(param, function (data) {
				self.goodsAmount = data.goodsAmount;
				self.quantity = data.quantity;
				self.categoryNum = data.categoryNum;
				e.item.quantity = data.qty;
				e.item.subtotal = (e.item.quantity * e.item.purchasePrice).toFixed(2);
				if (e.item.quantity == 0) {
					for (var i = 0; i < self.goods.length; i++) {
						if (self.goods[i].goodsUuid == e.item.goodsUuid) {
							self.goods.splice(i, 1);
							if (self.goods && self.goods.length > 0) {
								self.detail = self.goods[0];
								self.update();
								$(".product-li ul li").eq(0).addClass("active");
							} else {
								$(".s-pro-d").hide();
							}
						}
					}
				}
				self.update();
			});
		}

		forDetail(e) {
			$(".product-li ul li").removeClass("active");
			$(e.currentTarget).addClass("active");
			$(".s-pro-d").show();
			self.detail = e.item;
			if (self.detail.imageUrl) {
				self.detail.imageUrl = e.item.imageUrl.replace('-min', '-normal');
			}

		}

		flux.bind.call(self, {
			name: 'supplierList',
			store: store.supplierList,
			params: {},
			success: function () {
				self.update();
			}
		});

		getGoods() {
			return function (item) {
				self.goodsAdd(item);
			}
		}

		self.searchOpts = {
			clickHandle: self.getGoods()
		};

		self.on('mount', function () {
			window.addEventListener('inputNumber', self.scanCodeStorage, false);
		});

		self.on('unmount', function () {
			store.stockCommit.clear({type: type});
			window.removeEventListener('inputNumber', self.scanCodeStorage);
		})

		self.updatePrice = function (data) {
			var params = {
				// barcode,goodsName,price,purchasePrice,cateId,stockNum,goodsUuid
			}

		}

		self.goodsAdd = function (e) {
			var param = {
				type: type
			};
			param.goodsUuid = e.goodsUuid;
			store.stockAdd.get(param, function (data) {
				if (!data.goods.purchasePrice) {
					$("#storageAddPurchasePrice")[0].open(data.goods);
					return;
				}
				self.categoryNum = data.categoryNum;
				self.quantity = data.quantity;
				self.goodsAmount = data.goodsAmount;
				var goods = false;
				if (self.goods && self.goods.length > 0) {
					goods = true;
				} else {
					self.goods = [];
				}
				if (goods) {
					var hasSame = false;
					for (var i = 0; i < self.goods.length; i++) {
						if (self.goods[i].goodsUuid == data.goods.goodsUuid) {
							if (data.goods.imageUrl) {
								data.goods.imageUrl = data.goods.imageUrl.split("?")[0] + "-min";
							}
							data.goods.subtotal = (data.goods.quantity * data.goods.purchasePrice).toFixed(2);
							self.goods[i] = data.goods;
							hasSame = true;
						}
					}
					if (!hasSame) {
						var newList = [];
						data.goods.subtotal = (data.goods.quantity * data.goods.purchasePrice).toFixed(2);
						if (data.goods.imageUrl) {
							data.goods.imageUrl = data.goods.imageUrl.split("?")[0] + "-min";
						}
						newList.push(data.goods);
						self.goods = self.goods.concat(newList);
					}
				} else {
					data.goods.subtotal = (data.goods.quantity * data.goods.purchasePrice).toFixed(2);
					if (data.goods.imageUrl) {
						data.goods.imageUrl = data.goods.imageUrl.split("?")[0] + "-min";
					}
					self.goods.push(data.goods);
					self.detail = self.goods[0];
					if (self.detail.imageUrl) {
						self.detail.imageUrl = self.goods[0].imageUrl.replace('-min', '-normal');
					}
					$(".s-pro-d").show();
					self.goods[0].active = true;
				}
				self.update();
			});
		}
	</script>
</storage-in>
