<shop-setting>
	<div class="half">
		<div class="setting-shop { active:message.bindDevice }" onclick="{ setting }">
			打开收银机默认登录此店铺
		</div>
	</div>
	<div class="half">
		<div class="shop-bind" if="{ qrcode.bqStoreId }">
			<ul>
				<li>
					<span>已绑定 { qrcode.bqStoreName }</span>
					<a onclick="{ removeBind }">解除绑定</a>
					<div class="clearfix">
					</div>
				</li>
				<li>
					<span>上次数据同步完成时间: { qrcode.bindTime || '暂未同步'}</span>
					<a onclick="{ dataSyn }">数据同步</a>
					<a onclick="{ dataCalibration }">数据校准</a>
					<div class="clearfix">
					</div>
				</li>
			</ul>
		</div>
		<div class="code" if="{ qrcode.qrCodeUrl }">
			<div class="title">
				绑定倍全店铺
				<i>(使用倍全商户端APP内的扫码功能)</i>
			</div>
			<div class="img">
				<img src="{ qrcode.qrCodeUrl }" alt=""/>
			</div>
		</div>
		<div class="shop-bind" if="{ !qrcode.qrCodeUrl && !qrcode.bqStoreId }">
			系统异常
		</div>
	</div>
	<script>
		var self = this;
		self.shopBind = false;

		self.getMessage = function () {
			httpGet({
				url: api.storeMessage,
				params: {},
				success: function (res) {
					self.message = res.data;
					self.update();
				}
			});
		}

		self.getQrcode = function () {
			httpGet({
				url: api.oauthQrcode,
				params: {},
				success: function (res) {
					self.qrcode = res.data;
					if (self.qrcode && self.qrcode.bindTime) {
						self.qrcode.bindTime = self.qrcode.bindTime.substring(0,self.qrcode.bindTime.length-3)
					}
					self.update();
				}
			});
		}

		self.dataCalibration = function () {
			httpGet({
				url: api.clearAllGoodsAndSync,
				params: {},
				success: function () {
					utils.toast("开始校准")
				}
			});
		}

		self.removeBind = function () {
			httpGet({
				url: api.oauthTokenClean,
				params: {},
				success: function (res) {
					utils.toast('解除绑定成功');
					self.getQrcode();
				}
			});
		}

		self.dataSyn = function () {
			httpPost({
					url: api.syncBqinfo,
					params: {},
					success: function(res) {
						utils.toast('开始同步数据')
					}
			});
		}

		self.setting = function () {
			self.message.bindDevice = !self.message.bindDevice
			self.update();
			var params = {
				bindDevice: self.message.bindDevice,
				imeCode: self.imeCode
			};
			httpPost({
					url: api.bindDevice,
					params: params,
					success: function(res) {
							if (success) {
									success(res);
							}
					},
					complete: function(res) {
							utils.loadHide();
					}
			});
		}

		self.getReceiveBind = function () {
			// 绑定成功
			self.mes = JSON.parse(Ipush.message);
			if (self.mes.type == CONSTANT.PUSH_LOGIN_BIND) {
				utils.toast('绑定成功');
				self.getQrcode();
			} else if (self.mes.type == CONSTANT.PUSH_GET_CODE) {
				self.getQrcode();
			}
		}

		self.on('mount', function () {
			self.getMessage();
			self.getQrcode();
			if(window.Iapps){
				Iapps.getImei(
					function(res) {
						if (res.imei) {
							self.imeCode = res.imei;
							self.update();
						}
					},
					function(err) {},
					{}
				)
			}
			window.addEventListener('receiveMessage', self.getReceiveBind, false);
		});

		self.on('unmount', function () {
			window.removeEventListener('receiveMessage', self.getReceiveBind);
		});
	</script>
</shop-setting>
