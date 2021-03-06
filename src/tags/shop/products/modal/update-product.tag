<update-product>
	<form id="update-product-form" name="update-product">
		<input type="hidden" value="{ data.goodsUuid }" name="goodsUuid">
		<label>
			条码：
			<input value="{ data.barcode }" name="barcode" class="long-input" readonly="readonly"/>
		</label>
		<label>
			商品名：
			<input type="text" value="{ data.goodsName }" name="goodsName" class="long-input" maxlength="64"/>
		</label>

		<div class="edit-area">
			<label>
				零售价（元）：
				<input type="tel" value="{ data.price }" name="price" maxlength="8"/>
			</label>
			<label>
				进货价（元）：
				<input type="tel" value="{ data.purchasePrice }" name="purchasePrice" maxlength="8"/>
			</label>

			<label>
				分类：
				<select name="cateId">
					<option each="{ categorySelect }" value="{ cateId }" selected="{ cateId==currentCateId }">{ cateName }</option>
				</select>
			</label>
			<label>
				库存：
				<input type="tel" value="{ data.stockNum || 0 }" name="stockNum" maxlength="10"/>
			</label>
			<input type="hidden" name="imageUrl" id="update-product-imgUrl">
		</div>

		<div class="img-area" id="update-product-img">
			<img src="{ data.imageUrl || 'imgs/default-product.png'}">
		</div>
	</form>

	<script>
		var self = this;
		self.type = 'update';
		self.cates = new Array();
		var modal = self.parent;
		var cash = self.parent.parent;
		modal.onOpen = function (params) {
			self.data = {
				purchasePrice: " "
			};
			self.update();
			self.data = params;
			self.update();
			self.currentCateId = self.data.cateId;
			utils.createUploader({
				idName: 'update-product-img',
				container: 'prodcut-detail',
				success: function (up, file, info) {
					var domain = up.getOption('domain');
					var res = $.parseJSON(info);
					var sourceLink = domain + res.key;
					$('#update-product-imgUrl').val(sourceLink);
					self.data.imageUrl = sourceLink + "?imageView2/1/w/200/q/50";
					self.update();
				}
			});
			self.update();
		}

		modal.onClose = function () {
			$('.moxie-shim').remove();
			self.data = {
				purchasePrice: " "
			};
			self.update();
		}

		modal.onSubmit = function () {
			var params = $('#update-product-form').serializeObject();
			params.parentCateId = cash.cateId;
			if (!params.goodsName) {
				utils.toast('请输入商品名');
				return;
			}

			if (!/^(0|[1-9][0-9]{0,9})(\.[0-9]{1,2})?$/.test(params.price)) {
				utils.toast('请输入正确的零售价');
				return;
			}
			params.purchasePrice = params.purchasePrice.trim();
			if (params.purchasePrice != "") {
				if (!/^(0|[1-9][0-9]{0,9})(\.[0-9]{1,2})?$/.test(params.purchasePrice)) {
					utils.toast('请输入正确的进货价');
					return;
				}
			}

			if (params.stockNum != "") {
				if (!/^\d+$/.test(params.stockNum)) {
					utils.toast('请输入正确库存');
					return;
				}
			}

			store.goods.update(params, function () {
				utils.toast('修改成功');
				store.loadTopGoodsList = true;
				modal.close();
				self.data = {
					purchasePrice: " "
				};
				self.update();
			});
		}

		modal.onDelete = function () {
			if (confirm('确认删除该商品么?')) {
				var params = {
					goodsUuid: self.data.goodsUuid,
					parentCateId: cash.cateId
				}
				store.goods.delete(params, function () {
					utils.toast('删除成功');
					store.loadTopGoodsList = true;
					cash.getGoodsCount(cash.cateId);
					modal.close();
					self.data = {
						purchasePrice: " "
					};
					self.update();
				});
			}
		}

		flux.bind.call(self, {
			name: 'categorySelect',
			store: store.categorySelect
		});

		self.on('mount', function () {
			if (store.online) {
				var gotimeout;
				$("#update-product-form").find("input").focus(function () {
					if ($(this).attr("readonly") != "readonly") {
						clearTimeout(gotimeout);
						$(".modal-dialog").css("top", "220px");
					}
				});
				$("#update-product-form").find("input").blur(function () {
					gotimeout = setTimeout(function () {
						$(".modal-dialog").css("top", "50%");
					}, 200);
				});
			}
		});
	</script>
</update-product>
