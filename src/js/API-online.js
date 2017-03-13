//var iposHeader = "http://192.168.1.50:8081/admin";
// var iposHeader= "http://192.168.1.154:8080/pos";
//var iposHeader= "http://zm.store.meilizongjian.com/pos";
// if (location.host.match(/localhost/)) {
// 	window.iposHeader = "http://" + location.host + "/pos";
// }
// else {
	// window.iposHeader = "https://pos.ipos100.cn/pos";					//pos正式环境地址
	// window.iposHeader = "http://60.205.106.238:8080/pos";			//pos测试环境地址
	window.iposHeader = "http://dev.pos.ipos100.cn/pos";		//测试环境

	// window.iposHeader = "http://60.205.106.238:8080/pos";
	// window.iposHeader = "http://192.168.1.5:8080/pos";
// }
//var iposHeader = "http://101.201.43.34:8080/pos";
//var iposHeader = "/posc";

var onlineApi = {
	//qiniu token
	qiniuToken: 'qiniu/uptoken',   // 7牛上传图片token
	//search
	searchGoods: 'Ishop.goodsSearch',

	//weather
	weather: 'store/weather',     //天气
	//store/login
	login: 'Icommon.login',
	logout: 'Icommon.logout',
	lastLogin: 'Icommon.lastLogin',
	register: 'store/register/commit',    //注册提交
	registerNext: 'store/register/next',   //注册下一步
	sendCode: 'store/checkcode/send',      //短信验证码
	//region
	region: 'store/region/list',            //地址

	pwdCode: 'store/pwdfind/sendcode',     //找回密码短信验证码
	pwdSet: 'store/pwdfind/commit',         //找回密码提交

	auth: 'Ishop.userPermissionCodes',


	//goods
	goods: 'Ishop.goodsList',
	goodsTop: 'Ishop.goodsToplist',
	goodDetail: 'Ishop.goodsGet',
	goodSearch: 'Ishop.goodsSearch',
	category: 'Ishop.goodsCategoryList',
	categoryAll:'Ishop.goodsCategoryListAdd',
	deleteGood: 'goods/del',                     //删除商品
	createGood: 'goods/addOrUpdate',             //添加或更新商品
	updateGood: 'goods/addOrUpdate',
	goodByBarcode: 'Ishop.goodsGetByBarcode',
	goodBySpecBarcode: 'goods/spec/getByBarcode',    //获取spu库商品信息
	goodImport: 'goods/import',                       //商品导入

	//设备管理：
	printerInfo: 'Iprinter.getPrint',
	printTest: 'Iprinter.testPrint',
	switchPrinter: 'Iprinter.setPrint',
	printQr: 'Iprinter.setPrintQr',
	printBill: 'Iprinter.setPrintBill',

	//销售单/退货单
	salesOrder: 'Iorder.billListByDate',
	orderGoods: 'Iorder.billGoodsList',
	printOrder: 'Iorder.billPrint',

	//employee
	employees: 'Ishop.userList',
	updateEmployee: 'user/addOrUpdate',             //员工添加或更新
	delEmployee: 'user/del',                       //员工删除

	//store message
	storeMessage: 'Ishop.storeGet',
	updateMessage: 'store/update',                    //店铺更新
	showAds: 'Ishop.showAds',
	bindDevice: 'store/bindDevice',  // 倍全绑定店铺
	//shoppingcart
	listCart: 'Icash.shoppingcartList',
	changeCart: 'Icash.shoppingcartChange',
	clearCart: 'Icash.shoppingcartClear',

	addCart: 'Icash.shoppingcartGoodsIncr',
	reduceCart: 'Icash.shoppingcartGoodsDecr',
	addNoName: 'Icash.shoppingcartAddMoney',

	cartByScan: 'Icash.shoppingcartEnterAndAdd',
	openBox: 'Icommon.openBox',
	addBill: 'Icash.tmpbillAdd',
	reviewBill: 'Icash.tmpbillTakeAndDel',
	listBill: 'Icash.tmpbillList',

	closeRefund: 'Icash.refundClose',
	startRefund: 'Icash.refundBillopen',

    setPay: 'Icash.billChange',
	changePay: 'Icash.payChangePayment',
	discountPay: 'Icash.payDiscount',
	wipePay: 'Icash.payWipe',
	payCoupon: 'Icash.payCoupon',
	payVip: 'Icash.payVip',

	commitPay: 'Icash.payCommit',
	commitPayNew:'Icash.payCommit',
	commitPayBpos:'Icash.payCommit',
	afterPayCommit: 'Icash.afterPayCommit', // 支付成功调打印
	modifyCartQuantity: 'Icash.shoppingcartGoodsQuantityModify', // 修改购物车数量

	//通道sys/set
	sysSet: 'Icommon.sendInfo',
	sysGet: 'sys/get',             //－－－－－－－－－－无用

	//订单

	orderHistory: 'order/history',             //历史订单
	orderToday: 'order/today',                 //今日订单
	orderRefuse: 'order/refuse',               //拒绝订单
	orderCancel: 'order/cancel',               //取消订单
	orderInvalid: 'order/invalid',             //订单无效
	orderConfirm: 'order/confirm',             //确认订单
	orderComplete: 'order/complete',           //完成订单
	upCanOrder: 'order/upCanOrder',           //改变接单状态
	storeInfo: 'order/storeInfo',         //店铺信息
	orderConfirmed: 'order/toBeConfirmed',     //待处理订单数量
	newOrderHint: 'order/newOrderHint',   //新订单通知
	printOrderDetail :'Iprinter.printOrder',  //打印订单
	gooduuidByBarcode: 'Ishop.goodsGetByBarcode',  //获取店铺数据

	//库存

	stockAdd : "stock/goods/add",                // 入库添加商品
	stockIncr : "stock/goods/incr",              // 增加商品数量
	stockDecr : "stock/goods/decr",              //减少商品数量
	stockCommit :"stock/commit",                 //生成库存单据
	stockClear :"stock/clear",                 //清空购物车

	stockListByDate:"stock/listByDate",          //查询库存单据
	stockGoodsList:"stock/goods/list",           //库存单据商品列表

	supplierAddOrUpdate:"supplier/addOrUpdate",   //供应商添加或更新
	supplierDel:"supplier/del",                   //删除供应商
	supplierList :"supplier/list",                //供应商列表

	// 我的数据
	dataDashboard :"data/dashboard",
	//2.4 经营助手
	getWeekSale: "data/sales/rank/date",												//1.本周排名
	saleByDate: "data/sales/simple/info",									//2.按日期查销售额
	weekMembers: "data/member/simple/info",								//6.会员、订单简报
	goodsRank: "data/sales/goods/rank",										//5、商品销售排名
	channelSale: "data/sales/channel/info",								//3、分渠道销售情况
	categoryScale: "data/sales/category/scale",						//4.各分类销售占比
	bestWarning: "data/sales/best/warning",								//7、畅销商品库存预警
	dullWarning: "data/sales/dull/warning",								//8、滞销商品提醒
	categoryRank: "data/sales/goods/rank/category",						//9、排名商品分类
	//down
	downTemplateExcel:"Icommon.downTemplateExcel",
	importTemplate : "goods/importTemplate",        //模板链接
	synTask:"Icommon.synTask",                    //同步商品接口－－有返回值
	downloadApp:"Idownload.download",              //下载app
	unInstall:"Idownload.unInstall",               //删除app
	downRegister:"Idownload.register",              //注册下载－－暂时没用
	appList:"app/list",                              //app列表
	getappinfo:"Idownload.getappinfo",               //app已下载列表
	showPayQrCode:"Ishop.storeQrInfoGet",             //获取店铺支付二维码

	judgeBqCommercial:"Icommon.judgeBqCommercial",     //获取是否是倍全店
	iposHeader:"Icommon.getServiceHost",                //获取服务器地址

  setOrderPrintState:"Iorder.setOrderPrintState",      //设置订单点确认打印
  getOrderPrintState:"Iorder.getOrderPrintState",     //获取设置订单点确认打印状态
  checkAppUpdateState:"Iapps.checkAppUpdateState",   //查看版本更新
  initPush:"Ipush.initPush",                          //首次

	getGoodsCountByCateId:"Ishop.getGoodsCountByCateId",   //商品分类数量

	//2.0
	couponVerify:"pay/coupon/verify",    //优惠券接口

	couponList:"store/coupon/list",        //优惠券列表
	couponInfo:"store/coupon/info",        //优惠券详情
	couponStop:"store/coupon/grant/stop",    //停止发放优惠券
	couponCreate:"store/coupon/grant/create",   //创建优惠券
	memberVerify:"store/member/verify",            //结算单会员登录

	attainList:"store/attain/list",   //成就列表
	attainReward:"store/attain/task/reach",   //领取奖励
	rewardList:"store/reach/reward/list",     //奖励列表
	rewardInfo:"store/reach/reward/info",      //奖励详情
	record:"store/entity/record",     // 打点

	mobileVerify:"store/mobile/verify",   //验证店老板修改奖励发放账户验证码
	rewardIncomeList:"store/reward/income/list",   //奖励收入记录
	bankCardAdd:"store/bank/card/add",     //绑定银行卡
	bankCardUpdate:"store/bank/card/update",     //修改绑定银行卡
	bankCard:"store/bank/card",      //查询银行卡绑定信息
	changeCardCodeSend:"store/changeCardCode/send",    //发送验证码
	advIncomeList:"store/adv/income/list",  //广告收入
	oauthQrcode: 'oauth/qrcode', // 获取绑定倍全店铺二维码
	oauthTokenClean: 'oauth/token/clean', // 解绑倍全
	syncBqinfo: 'sys/sync/bqinfo/manual', // 同步倍全数据
	clearAllGoodsAndSync: 'Ishop.clearAllGoodsAndSync'  // 	清除脏数据
};

for (var i in onlineApi) {
	//如果匹配到/，则认为是远程接口
	if (onlineApi[i].match(/\//)) {
		onlineApi[i] = iposHeader + '/' + onlineApi[i];
	}
}

module.exports = onlineApi;
