<login>
	<div id="login-wrap">
		<form class="login" onsubmit="{ submit }">
			<div class="logo"></div>
			<div class="setting" onclick="{ openSetting }"></div>
			<input id="username" type="text" name="username" placeholder="账号/手机号" maxlength="12">
			<input id="password" type="password" name="account" placeholder="密码" maxlength="12">
			<button class="login-btn">登录</button>
			<div class="tips">
				<a class="left" href="#/register">开店</a>
				<a class="right" href="#/find-password">找回店主密码</a>
			</div>
		</form>

	</div>
	<script>
		var self = this;

		self.openSetting = function () {
			if (window.Icommon) {
				Icommon.openSetting();
			}
		}

		self.submit = function (e) {
			e.preventDefault();
			var username = $('#username').val();
			var password = $('#password').val();
			if(!username){
				utils.toast("请填写用户名");
				return;
			}

			if(!password){
				utils.toast("请填写密码");
				return;
			}

			store.account.login({
				username: $('#username').val(),
				password: $('#password').val(),
				imeCode: '2021414914044566'
			}, function (data) {
				if (data.code == 1) {
					self.login = true;
					location.replace("#/casher/index");
					// location.hash = '#/casher/index';
					location.reload();
					// flux.update(store.auth);
				} else if (data.code == 20101) {
					self.login = false;
					$('#login-warning').show();
				} else if (data.msg) {
					alert(data.msg);
				}
			});
		};

		self.closeWarning = function () {
			$('#login-warning').hide();
		}
	</script>
</login>
