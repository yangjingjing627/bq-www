<register>
	<div id="login-wrap">
		<a class="back" onclick="{ goback }">返回</a>
		<div class="setting" onclick="{ openSetting }"></div>
		<form class="register" onsubmit="{ submit }">
			<h4>填写店长信息</h4>
			<input class="{ error: !verifyPhone }" value={ register.phoneMobile } type="text" name="phone" id="register-phone" maxlength="11" placeholder="手机号" />
			<label>
				<input class="{ error: !verifyCode }" value={ register.code } type="text" name="phone" id="checkcode" placeholder="验证码" />
				<a if={ firstSend } href="" onclick={ getCode } >获取</a>
				<a if={ !firstSend } onclick={ getCode } >
					再次获取
					<span if={ isCounting } id="countDown">{ countNum }</span>
					<b if={ isCounting }> s </b>
				</a>
			</label>
			<input type="password" value={ register.password } name="password" class="{ error: !verifyPWD }" id="rg-pwd" placeholder="店长密码(6-12位)" maxlength="12" ／>
			<input type="password" value={ register.password } class="{ error: !verifyRePWD }" placeholder="再次店长密码" id="rg-repwd" maxlength="12" ／>
			<input type="text" name="owner"  value={ register.personName } class="{ error: !verifyOwner }" id="owner-name" placeholder="店长姓名">
			<button onclick={ submit }>提交</button>
		</form>
	</div>
	<script>
		var self = this;
		self.countNum = 60;
		self.firstSend = true;
		self.verifyCode = self.verifyPhone = self.verifyOwner = self.verifyPWD = self.verifyRePWD = true;

		self.openSetting = function() {
			utils.androidBridge(api.openSetting)
		}

		function countDown(){
			var count = $('#countDown');
			if (count[0]){
				count.text(self.countNum--);

				if (self.countNum > -1){
					setTimeout(countDown, 1000);
				} else {
					self.isCounting = false;
					self.update();
				}
			}
		}

		flux.bind.call(self, {
			name: 'register',
			store: store.register,
			success: function () {
				self.update();
			}
		});

		self.getCode = function(e){
			e.preventDefault();

			var target = e.target;
			var phone = $('#register-phone').val();

			if (phone.match(/^1[0-9]{10}$/)){
				self.verifyPhone = true;

				if (self.isCounting) {
					return ;
				}

				self.firstSend = false;
				store.register.sendCode({
					phoneMobile: phone
				}, function(){
					self.isCounting = true;
					self.countNum = 60;
					self.update();
					countDown();
				});
			} else {
				self.verifyPhone = false;
				utils.toast("请填写正确的手机号");
			}
		}

		function autoLogin(){
			store.account.login({
				username: $('#register-phone').val(),
				password: $('#rg-pwd').val(),
				imeCode: '784372987'
			},function(data){
				// location.hash = '#/casher/index';
				location.replace("#/casher/index");
				location.reload();
			});
		}

		self.submit = function(e){
			e.preventDefault();
			var registerStore = store.register;

			self.verifyPhone = $('#register-phone').val().match(/^1[0-9]{10}$/) ? true : false;
			self.verifyCode = $('#checkcode').val() ? true : false;
			self.verifyOwner = $('#owner-name').val() ? true : false;
			self.verifyPWD = /^[0-9a-zA-Z]{6,12}$/.test($('#rg-pwd').val());
			self.verifyRePWD = $('#rg-pwd').val() == $('#rg-repwd').val() ? true : false;
			if(!self.verifyPhone){
				utils.toast("请填写正确的手机号");
				return;
			}
			if(!self.verifyCode){
				utils.toast("请填写正确的验证码");
					return;
			}
			if(!self.verifyPWD){
				utils.toast("请填写正确的密码");
				return;
			}
			if(!self.verifyRePWD){
				utils.toast("密码不一致");
				return;
			}
			if(!self.verifyOwner){
				utils.toast("请填写店长姓名");
				return;
			}
			if (self.verifyPhone && self.verifyOwner && self.verifyPWD && self.verifyRePWD) {
						//to-do set warning
						utils.loadShow();
						self.register.bindDevice = true;
						var params = {
							channel: 'bpos',
							bindDevice: true,
							phoneMobile: $('#register-phone').val(),
							code: $('#checkcode').val(),
							personName: $('#owner-name').val(),
							password: $('#rg-pwd').val()
						}
						if(self.imeCode){
							params.imeCode = self.imeCode;
						}
						httpPost({
							url: api.register,
							params: params,
							success: function(res){
								autoLogin();
							},
							complete: function(res) {
									utils.loadHide();
							}
						});
			}
		};
		self.goback = function() {
			utils.androidBridge(api.goLogin)
		}
		self.on('mount', function(){
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
		})
	</script>
</register>
