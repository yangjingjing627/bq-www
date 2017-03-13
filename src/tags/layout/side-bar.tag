<side-bar>
	<div id="side-bar">
		<div class="header">
			<div class="avator" onclick={ openTip }></div>
			<div class="account-name" onclick={ openTip }>{ accountName || '用户名'}</div>
			<div class="right-tip" style="display:none">
				<div class="tri"></div>
				<a onclick={ openAbout }>关于我们</a>
				<a onclick={ logout }>退出账户</a>
			</div>
		</div>
		<div class="side-menu">
			<ul>
				<li class="{ active: type=='casher'||type==''}">
					<a href="#/casher/index">
						<div class="menu-pic m-casher"></div>
						<div class="menu-title">收银</div>
					</a>
				</li>
				<li class="{ active: type=='shop'}">
					<a href="#/shop/index">
						<div class="menu-pic m-store"></div>
						<div class="menu-title">店铺</div>
					</a>
				</li>
				<!-- <li class="{ active: type=='order'}" if={ !isBqCommercial }>
					<a href="#/order/index">
						<div class="menu-pic m-order">
							<div class="order-untreated" style="display:none"></div>
						</div>
						<div class="menu-title">订单</div>
					</a>
				</li> -->
				<li class="{ active: type=='app'}">
					<a href="#/app/index">
						<div class="menu-pic m-app"></div>
						<div class="menu-title">应用</div>
					</a>
				</li>
			</ul>
			<div class="setting" onclick="{ openSetting }"></div>
		</div>
		<modal id="about-layer" model-width="400px" model-height="512px" without-delete noFooter>
			<div class="about">
				<div class="about-close" onclick="{ close }"></div>
				<h2>关于</h2>
				<img class="logo" width="106" src="imgs/logo.png"/>
				<!-- 	<p>开店宝云POS</p> -->
				<p>版本： { parent.version }
				</p>
				<!-- 				<img class="wechat" width="150" src="imgs/pay-code.png" /> -->
				<!-- 				<p>微信公众号：开店宝</p> -->
				<span class="red-box" onclick={ parent.checkAppUpdateState }>检测更新</span>
			</div>
		</modal>
	</div>

	<script>
		var self = this;

		function active() {
			self.type = location.hash.substr(2).split('/')[0].replace(/\?\S+/, '');
			self.update();
			if ((self.type == 'casher') || (self.type == 'shop') || (self.type == 'app')) {
				self.checkUserIsLogin();
			}
		}

		flux.bind.call(self, {
			name: 'account',
			store: store.account,
			success: function () {
				self.accountName = self.account
					? self.account.personName
					: '用户名';
				self.update();
			}
		});

		self.checkAppUpdateState = function () {
			httpGet({url: api.checkAppUpdateState});
		}

		self.toBeConfirmed = function () {
			store.orderConfirmed.get(function (data) {
				if (data > 0) {
					$(".order-untreated").show().text(data);
				} else {
					$(".order-untreated").hide();
				}
			});
		}

		self.openTip = function () {
			var e = window.event;
			e.preventDefault();
			if (e && e.stopPropagation) {
				e.stopPropagation();
			}
			$('.right-tip').toggle();
			function closeTip() {
				$('.right-tip').hide();
				$(window).unbind('click', closeTip);
			}
			setTimeout(function () {
				$(window).bind('click', closeTip);
			}, 100);
		};

		self.openAbout = function () {
			$('#about-layer')[0].open();
		};

		self.closeAbout = function () {
			$('#about-layer')[0].close();
		}

		self.logout = function () {
			store.account.logout();
			location.hash = "#login";
		}

		self.openSetting = function () {
			utils.androidBridge(api.openSetting)
		}

		// 接收推送，同步商品
		self.getReceiveSyn = function () {
			self.message = JSON.parse(Ipush.message);
			if (self.message.type == CONSTANT.PUSH_DATA_SYN) {
				store.synTask.get({name: "Goods",noloadShow: true}, function (success) {});
				store.synTask.get({name:"GoodsCategory",noloadShow: true}, function (success) {});
			} else if (self.message.type == PUSH_GET_STORE) {
				store.synTask.get({name: "Store",noloadShow: true}, function (success) {});
			}
		}

		self.checkUserIsLogin = function () {
			var storeInfo = {}
			if (window.localStorage && localStorage.account) {
				storeInfo = JSON.parse(localStorage.account)
			}
			if (!storeInfo.storeId) {
				location.href = "#login";
			}
		}

		self.on('mount', function () {
			self.checkUserIsLogin();
			if (window.Iapps) {
				Iapps.getVersion(function (res) {
					if (res.version) {
						self.version = res.version;
						self.update();
					} else {
						self.version = "V1.0.0 Beta";
						self.update();
					}
				}, function (err) {}, {})
			} else {
				self.version = "V1.0.0 Beta"
			}
			setTimeout(self.toBeConfirmed, 500);
			//订单数量变化
			window.addEventListener('orderNumChange', self.toBeConfirmed);
			window.addEventListener('receiveMessage', self.getReceiveSyn, false);
		});

		self.on('unmount', function () {
			window.removeEventListener('orderNumChange', self.toBeConfirmed);
			window.removeEventListener('receiveMessage', self.getReceiveSyn);
		});

		riot.routeParams.on('changed', active);
		active();
	</script>
</side-bar>
