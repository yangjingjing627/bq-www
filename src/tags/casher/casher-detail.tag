<casher-detail>
	<div class="detail white-box" if={ detail }>
		<div class="pic" style={ detail.imageUrl ? 'background-image:url('+ detail.imageUrl +')' : 'background-image:url(imgs/default-400.png)'}></div>
		<p>{ detail.goodsName || '无码商品' }</p>
		<p>条码：{ detail.barcode || '无' }</p>
		<p>单位：{ unit || '无' }</p>
		<div class="modify-cart">
			<label>数量：</label>
			<span onclick="{ modifyCart }">{ detail.weight }</span>
		</div>
		<strong>￥{ detail.price }</strong>
		<i class="line" style="display:none"></i>
		<div class="more"  style="display:none">
			<span>13811468801</span>
		</div>
		<modal id="modifyCartqu" modal-width="500px" opts={ modalCartOpts }>
			<div class="wrap">
					<div class="content">
						<label for="">商品数量：</label>
						<input id="" type="tel" maxlength="9"/>
					</div>
			</div>
		</modal>
	</div>

	<script>
		var self = this;
		flux.bind.call(self, {
			name: 'detail',
			store: store.detail,
			success: function () {
				self.update();
				if (self.detail) {
					self.unit = CONSTANT.UNITS[self.detail.unit]
				}
				self.update();
			}
		});

		self.modalCartOpts = {
				onOpen: function () {
					$('#modifyCartqu').find('input').val(self.detail.weight);
				},
				onSubmit: function(){
					self.submitModifyCart();
				},
				onClose: function(){
					$('#modifyCartqu').find('input').val('');
				}
		};

		self.submitModifyCart = function () {
			var quantity = $('#modifyCartqu').find('input').val() * 1;
			if (!$('#modifyCartqu').find('input').val()) {
				utils.toast("数量不能为空")
				return
			}
			if (quantity > 2000) {
				utils.toast("数量不能超过2000")
				return
			}
			var unit = self.detail.unit
			// 单位是千克，克，毫升，升，斤时，可以输入3位小数，
			if (unit == 5 || unit == 6 || unit == 7 || unit == 8 || unit == 9) {
				if (!/^[0-9]+([.]{1}[0-9]{1,3})?$/.test(quantity)) {
					utils.toast("请输入正确的数量")
					return
				}
			} else {
				if (!/^(0|\+?[1-9][0-9]*)$/.test(quantity)) {
					utils.toast("请输入正确的数量")
					return
				}
			}
			var params = {
				goodsUuid: self.detail.goodsUuid,
				weight: quantity
			};
			self.update();
			$('#modifyCartqu')[0].close();
			// if (weight == 0) {
			// 	store.detail.set(self.detail);
			// 	store.cart.update(self.detail.goodsUuid, self.resData);
			// } else {
			// 	console.log($('#modifyCartqu'));
			// 	$('#modifyCartqu')[0].close();
			// 	store.detail.set(self.detail);
			// 	store.cart.update(self.detail.goodsUuid, self.resData);
			// }
			httpPost({
					url: api.modifyCartQuantity,
					params: params,
					success: function(res) {
						store.cart.update(self.detail.goodsUuid, res.data);
						store.detail.set(res.data.goods);
					}
			});

			$('#modifyCartqu').find('input').val('');
		}

		self.modifyCart = function () {
			$('#modifyCartqu')[0].open();
			$('#modifyCartqu').find('input').focus();
		}
	</script>
</casher-detail>
