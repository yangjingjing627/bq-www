<pay-waiting>
  <div class="title">
    { title_text }
  </div>
  <div class="modal-submit">
    <div class="button-wrap">
      <!-- <a class="btn btn-default cancle" onclick="{ cancle }" if="{ pay_status == 1 }">取消</a> -->
      <a class="btn btn-primary submit" onclick="{ payFail }" if="{ pay_status == 4 }">知道了</a>
      <a class="btn btn-primary submit" onclick="{ paySuccess }" if="{ pay_status == 2 }">知道了</a>
      <a class="btn btn-default cancle" onclick="{ cancle }" if="{ pay_status == 3 }">支付失败</a>
      <a class="btn btn-primary submit" if="{ pay_status == 3 }" onclick="{ paySuccess }">支付成功</a>
    </div>
    <div class="clearfix"></div>
  </div>
  <script>
  var self = this;
  var modal = self.parent;
  var parent = self.parent.parent;
  self.title_text = '等待用户支付';
  self.pay_status = 3;
  modal.onOpen = function (params) {
    self.data = params;
    if (params.pay_status == CONSTANT.PUSH_PAY_SUCCESS) {
      // 支付成功
      self.title_text = '支付成功';
      self.pay_status = 2;
    } else if (params.pay_status == CONSTANT.PUSH_PAY_ING){
      self.title_text = '用户支付中...';
      self.pay_status = 3;
    } else if (params.pay_status == CONSTANT.PUSH_PAY_FAIL){
      self.title_text = '支付失败';
      self.pay_status = 4;
    } else {
      self.title_text = '等待用户支付';
      self.pay_status = 3;
    }
    self.update();
  }

  self.paySuccess = function () {
    modal.close();
    if (self.data && self.data.bill) {
      store.pay.afterPayCommit({bill: self.data.bill });
    }
    parent.paySuccess();
    // location.hash = '#/casher/index';
  }

  self.payFail = function () {
    modal.close();
    parent.bill = {};
    // parent.paySuccess();
    location.hash = '#/casher/index';
  }

  self.cancle = function () {
    modal.close();
    parent.bill = {};
    location.hash = '#/casher/index';
  }
  </script>
</pay-waiting>
