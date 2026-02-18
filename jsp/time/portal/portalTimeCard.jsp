	<%--  
	MosP - Mind Open Source Project  
	Copyright (C) esMind, LLC  https://www.e-s-mind.com/  
	
	This program is free software: you can redistribute it and/or  
	modify it under the terms of the GNU Affero General Public License  
	as published by the Free Software Foundation, either version 3  
	of the License, or (at your option) any later version.  
	
	This program is distributed in the hope that it will be useful,  
	but WITHOUT ANY WARRANTY; without even the implied warranty of  
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
	GNU Affero General Public License for more details.  
	
	You should have received a copy of the GNU Affero General Public License  
	along with this program.  If not, see <http://www.gnu.org/licenses/>.  
	--%>  
	<%@ page  
	language     = "java"  
	pageEncoding = "UTF-8"  
	buffer       = "256kb"  
	autoFlush    = "false"  
	errorPage    = "/jsp/common/error.jsp"  
	%><%@ page  
	import = "jp.mosp.framework.base.MospParams"  
	import = "jp.mosp.framework.constant.MospConst"  
	import = "jp.mosp.framework.utils.MospUtility"  
	import = "jp.mosp.framework.utils.HtmlUtility"  
	import = "jp.mosp.platform.portal.action.PortalAction"  
	import = "jp.mosp.platform.portal.vo.PortalVo"  
	import = "jp.mosp.platform.utils.PfNameUtility"  
	import = "jp.mosp.time.constant.TimeConst"  
	import = "jp.mosp.time.portal.bean.impl.PortalTimeCardBean"  
	%>

	<!-- ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	<%@ page import = "jp.mosp.time.utils.TimeUtility" %>
	<!-- ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->

	<%  
	//VOを準備
	MospParams params = (MospParams)request.getAttribute(MospConst.ATT_MOSP_PARAMS);  
	PortalVo vo = (PortalVo)params.getVo();  
	//VOを取得できなかった場合  
	if (vo == null) {  
		// 処理終了  
		return;  
	}  

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見
	// 打刻画面表示用ユーザーか判定する
	boolean isTimeCardOnlyUser = TimeUtility.isTimeCardOnlyUser(params);  
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/19 メッセージリフレッシュ機能追加-追加　塩見
	// メッセージリフレッシュ秒数を取得する
	int messageRefleshTime = TimeUtility.getMessageRefreshTime(params);
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/19 メッセージリフレッシュ機能追加-追加　塩見

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 打刻専用画面の打刻ボタンを常に表示、勤怠設定がないときは無効にする-変更　塩見
	// ポータル出退勤ボタン表示用変数
	// (1：始業/終業、2：始業/定終業、3：始業/定終業/残終業、4：出勤、9：非表示)
	int timeButtonViewControlInt = 0;	// 出退勤ボタン制御（初期は1）
	// ポータル休憩ボタン表示用変数
	// (1：表示、2：非表示)
	int restButtonViewControlInt = 0;	// 出退勤ボタン制御（初期は2）

	// ポータル出退勤ボタン表示  (ログインユーザーの設定情報)
	// (1：始業/終業、2：始業/定終業、3：始業/定終業/残終業、4：出勤、9：非表示)  
	int timeButton = MospUtility.getInt(vo.getPortalParameter(PortalTimeCardBean.PRM_TIME_BUTTON));
	// ポータル休憩ボタン表示  (ログインユーザーの設定情報)
	// (1：表示、2：非表示)
	int restButton = MospUtility.getInt(vo.getPortalParameter(PortalTimeCardBean.PRM_REST_BUTTON));

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/7 打刻機能カスタマイズ-追加　塩見
	// 打刻社員名を取得  
	String recordEmployeeName = vo.getPortalParameter(PortalTimeCardBean.PRM_RECORD_EMPLOYEE_NAME);
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/7 打刻機能カスタマイズ-追加　塩見
	// 打刻専用ユーザーでログインしたときのポータル出退勤 / 休憩ボタンの表示制御
	if(isTimeCardOnlyUser){
		// ポータル出退勤ボタン表示  
		// (0:設定適用がない場合、1：始業/終業、2：始業/定終業、3：始業/定終業/残終業、4：出勤、9：非表示)  
		int timeButtonForSearchEmployee = MospUtility.getInt(vo.getPortalParameter(PortalTimeCardBean.PRM_TIME_BUTTON_FOR_SEARCH_EMPLOYEE)); 
		// ポータル休憩ボタン表示(0:設定適用がない場合、1：表示、2：非表示)  
		int restButtonForSearchEmployee = MospUtility.getInt(vo.getPortalParameter(PortalTimeCardBean.PRM_REST_BUTTON_FOR_SEARCH_EMPLOYEE));

		// 打刻ボタン表示コントロール変数の値を検索社員の設定用に変更する
		// 出退勤ボタン非表示選択の場合は0に書き換える
		if(timeButtonForSearchEmployee == 9){
			timeButtonForSearchEmployee = 0;
		}
		timeButtonViewControlInt = timeButtonForSearchEmployee;
		restButtonViewControlInt = restButtonForSearchEmployee;
	}else{
		// 打刻ボタン表示コントロール変数の値をログインユーザー用に変更する
		timeButtonViewControlInt = timeButton;
		restButtonViewControlInt = restButton;
	}
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 打刻専用画面の打刻ボタンを常に表示、勤怠設定がないときは無効にする-変更　塩見

	System.out.println("DEBUG isTimeCardOnlyUser = " + isTimeCardOnlyUser);
	System.out.println("DEBUG timeButtonViewControlInt = " + timeButtonViewControlInt);
	System.out.println("DEBUG timeButton = " + timeButton);

	%>
	<div id="divTimeCard" class="TimeCard">  
	<%  
	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見
	if (isTimeCardOnlyUser) {
	%>  
		<script>
			// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 打刻表示用画面の時はログアウトボタンを表示しない-追加　塩見
			// ログアウトボタンを表示しない
			const logoutBtn = document.querySelectorAll('.LogoutButton');
			logoutBtn.forEach(el => {
				el.style.display = 'none';
			});
			// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 打刻表示用画面の時はログアウトボタンを表示しない-追加　塩見
			
			// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 打刻専用ユーザーでログインしたとき社員番号入力ボックス読み込んだらフォーカスを当てる処理を追加-追加　塩見
			const inputElementId = 'txtEmployeeCode';
			let inputEle = null;
			function inputElementFocus(){
				inputEle = document.getElementById(inputElementId);
				let inputTimeoutId;

				if(!inputEle){
					return;
				}

				// 初回のフォーカス
				inputEle.focus();

				// フォーカスが外れたとき
				inputEle.addEventListener('blur',() => {
					inputTimeoutId = setTimeout(() => {
						inputEle.focus();
					// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/24 フォーカスを戻す秒数を1秒に変更-変更　塩見
					},100);
					// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/24 フォーカスを戻す秒数を1秒に変更-変更　塩見
				});

				// 再度フォーカスされた場合は、タイマーをキャンセルする
				inputEle.addEventListener('focus',() => {
					if(inputTimeoutId){
						clearTimeout(inputTimeoutId);
						inputTimeoutId = null;
					}
				});
			}
			// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 打刻専用ユーザーでログインしたとき社員番号入力ボックス読み込んだらフォーカスを当てる処理を追加-追加　塩見
		</script>
		<%-- ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/19 打刻専用ユーザーでログインをした時のみ日付と時刻の表示位置を変更する-追加　塩見 --%>
		<div class="stcCustomTimeCardDateTimeDiv">
			<p id="stcCustomTimeCardDate"></p>
			<p id="stcCustomTimeCardTime"></p>
		</div>
		<%-- ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/19 打刻専用ユーザーでログインをした時のみ日付と時刻の表示位置を変更する-追加　塩見 --%>

		<div class="EmpSearchField">
			<span class="EmpSearchTitleTd"><%= PfNameUtility.employeeCode(params) %></span>  
			<%-- ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 読み込み時に社員番号入力欄にフォーカスを当て、初期入力モードを半角英数字にする-追加　塩見 --%>
			<input type="text" autocomplete="off" class="Code10RequiredTextBox EmpSearchInputText" id="txtEmployeeCode" name="txtEmployeeCode" inputmode="numeric" value="<%= HtmlUtility.escapeHTML(vo.getPortalParameter(PortalTimeCardBean.PRM_EMPLOYEE_CODE) != null ? vo.getPortalParameter(PortalTimeCardBean.PRM_EMPLOYEE_CODE) : "") %>" />
			<script>inputElementFocus();</script>			
			<%-- ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 読み込み時に社員番号入力欄にフォーカスを当て、初期入力モードを半角英数字にする-追加　塩見 --%>

			<button type="button" class="EmployeeClearButton stcCustomBtn" id="btnClearEmployeeCode" onclick="clearEmployeeCode();">クリア</button>

			<%-- ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/7 打刻専用ユーザーでログインしたときのメッセージ及びエラーメッセージ表示欄を社員番号検索ボックスの下部に変更-変更　塩見 --%>
			<p id="recordEmployeeNameBox">
				<% if(recordEmployeeName != null && !recordEmployeeName.isEmpty()) { %>
					<span id="recordEmployeeName"><%= recordEmployeeName%></span>
				<% }%>
			</p>
			<p id="messageArea_StcCustom"></p>
			<p id="errorMessageArea_StcCustom"></p> 
			<%-- ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/7 打刻専用ユーザーでログインしたときのメッセージ及びエラーメッセージ表示欄を社員番号検索ボックスの下部に変更-変更　塩見 --%>
			
			<%-- ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 検索ボタンを押下したときのクリックイベントにバリデーションチェックを追加した関数を指定-変更　塩見 --%>
				<button type="button" class="SearchEmployeeButton stcCustomBtn" id="btnSearchEmployeeInf" onclick="handleSearch();">検索</button>  
			<%-- ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 検索ボタンを押下したときのクリックイベントにバリデーションチェックを追加した関数を指定-変更　塩見 --%>
		</div>   
	<%  
	}  
	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/8/21 日付・時刻欄を非表示にする-変更　塩見
	%>  

		<table class="Time">  
			<tr>  
				<td class="TimeCardDateTd"><span id="lblTimeCardDate"></span></td>  
				<td rowspan="2">  
					<table>  
						<tr>  
							<td>  
	<%  
	if (timeButtonViewControlInt == 1 || timeButtonViewControlInt == 2 || timeButtonViewControlInt == 3 || timeButtonViewControlInt == 0) {  
		if (isTimeCardOnlyUser) {  
	%>  
			<button type="button" class="TimeCardButton" id="btnStart" onclick="submitTransfer(event, '', null, new Array( '<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_START_WORK_FOR_EMPLOYEE %>','txtEmployeeCode', document.getElementById('txtEmployeeCode').value),'<%= PortalAction.CMD_REGIST %>' );"><%= params.getName("StartWork") %></button>  
	<%  
		} else {  
	%>  
			<button type="button" class="TimeCardButton" id="btnStart" onclick="submitTransfer(event, '', null, new Array( '<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_START_WORK %>'),'<%= PortalAction.CMD_REGIST %>' );"><%= params.getName("StartWork") %></button>
	<%  
		}  
	}  
	if (timeButtonViewControlInt == 1 || timeButtonViewControlInt == 0) {  
		if (isTimeCardOnlyUser) { 
	%>  
			<%-- ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 終業ボタン押下時に確認ポップアップが表示されないように変更-変更　塩見 --%>
			<button type="button" class="TimeCardButton" id="btnEnd" onclick="submitTransfer(event, '', null, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_END_WORK_FOR_EMPLOYEE %>', 'txtEmployeeCode', document.getElementById('txtEmployeeCode').value),'<%= PortalAction.CMD_REGIST %>');"><%= params.getName("EndWork") %></button>
			<%-- ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 終業ボタン押下時に確認ポップアップが表示されないように変更-変更　塩見 --%>
	<%  
		} else {  
	%>  
			<button type="button" class="TimeCardButton" id="btnEnd" onclick="submitTransfer(event, '', null, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_END_WORK %>'), '<%= PortalAction.CMD_REGIST %>');"><%= params.getName("EndWork") %></button>  
	<%  
		}
	}  
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見
	if (timeButton == 2 || timeButton == 3) {  
	%>  
			<button type="button" class="TimeCardButton" id="btnRegularEnd" onclick="submitTransfer(event, '', applicationCheck, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_REGULAR_END %>'), '<%= PortalAction.CMD_REGIST %>');"><%= params.getName("RegularTime", "EndWork") %></button>  
	<%  
	}  
	if (timeButton == 3) {  
	%>  
			<button type="button" class="TimeCardButton" id="btnOverEnd" onclick="submitTransfer(event, '', null, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_OVER_END %>'), '<%= PortalAction.CMD_REGIST %>');" style="background-color: yellow;"><%= params.getName("OvertimeWork", "EffectivenessExistence", "EndWork") %></button>  
	<%  
	}  
	if (timeButton == 4) {  
	%>  
			<button type="button" class="TimeCardButton" id="btnRegularWork" onclick="submitTransfer(event, '', applicationCheck, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_REGULAR_WORK %>'), '<%= PortalAction.CMD_REGIST %>');"><%= params.getName("GoingWork") %></button>  
	<%  
	}  
	%>
							</td>  
						</tr>  
	<%  
	if (restButtonViewControlInt == 1 && timeButtonViewControlInt != 4) {  
		if (isTimeCardOnlyUser) { 
	%>  
			<%-- <button type="button" class="TimeCardButton" id="btnEnd" onclick="submitTransfer(event, '', null, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_END_WORK %>'), '<%= PortalAction.CMD_REGIST %>');"><%= params.getName("EndWork") %></button>  
						<tr>  
							<td>  
							<button type="button" class="TimeCardButton" id="btnRestStart" onclick="submitTransfer(event, '', null, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_START_REST %>'), '<%= PortalAction.CMD_REGIST %>');"><%= params.getName("RestTime", "Into") %></button>  
							<button type="button" class="TimeCardButton" id="btnRestEnd"   onclick="submitTransfer(event, '', null, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>', '<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_END_REST %>'), '<%= PortalAction.CMD_REGIST %>');"><%= params.getName("RestTime", "Return") %></button>  
							</td>  
			</tr>   --%>
	<%  
		} else {  
	%>  
			<tr>  
				<td>  
				<button type="button" class="TimeCardButton" id="btnRestStart" onclick="submitTransfer(event, '', null, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_START_REST %>'), '<%= PortalAction.CMD_REGIST %>');"><%= params.getName("RestTime", "Into") %></button>  
				<button type="button" class="TimeCardButton" id="btnRestEnd"   onclick="submitTransfer(event, '', null, new Array('<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>', '<%= PortalTimeCardBean.class.getName() %>','<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.RECODE_END_REST %>'), '<%= PortalAction.CMD_REGIST %>');"><%= params.getName("RestTime", "Return") %></button>  
				</td>  
			</tr>  
	<%
		}
	}
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見
	%>  

					</table>  
				</td>  

			</tr>  
			<tr>  
				<td class="TimeCardTimeTd">  
					<span id="lblTimeCardTime"></span>  
				</td>
			</tr>
		</table>  
	<%  
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/8/21 日付・時刻欄を非表示にする-変更　塩見
	if (params.getApplicationPropertyBool(TimeConst.APP_VIEW_PORTAL_TIME)) {  
	%>  
	<script language="Javascript">  
	<!--  
	var timeCardTime = new Date();  
	var srvTime = parseInt(jsTime);  
	var weeks = new Array('<%= params.getName("SundayAbbr") %>','<%= params.getName("MondayAbbr") %>','<%= params.getName("TuesdayAbbr") %>','<%= params.getName("WednesdayAbbr") %>','<%= params.getName("ThursdayAbbr") %>','<%= params.getName("FridayAbbr") %>','<%= params.getName("SaturdayAbbr") %>');  
	function timeCard() {  
		srvTime = srvTime +1000;  
		timeCardTime.setTime(srvTime);  
		setInnerHtml("lblTimeCardDate", getDate(timeCardTime));  
		setInnerHtml("lblTimeCardTime", getTime(timeCardTime));  

		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/19 打刻画面レイアウト変更対応-追加　塩見
		setInnerHtml("stcCustomTimeCardDate", getDate(timeCardTime));	// 打刻専用画面のみ表示する日付
		setInnerHtml("stcCustomTimeCardTime", getTime(timeCardTime));	// 打刻専用画面のみ表示する時刻
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/19 打刻画面レイアウト変更対応-追加　塩見
	}  
	timeCard();  
	window.setInterval(timeCard,1000);  
	
	function getDate(date) {  
		return date.getFullYear()  
		+ "<%= params.getName("Year") %>"  
		+ timeCardZeroSuppress(date.getMonth() + 1)  
		+ "<%= params.getName("Month") %>"  
		+ timeCardZeroSuppress(date.getDate())  
		+ "<%= params.getName("Day") %>"  
		+ "<%= params.getName("FrontParentheses") %>"  
		+ weeks[date.getDay()]  
		+ "<%= params.getName("BackParentheses") %>";  
	}  
	
	function getTime(date) {  
		return timeCardZeroSuppress(date.getHours())  
		+ "<%= params.getName("SingleColon") %>"  
		+ timeCardZeroSuppress(date.getMinutes())  
		+ "<%= params.getName("SingleColon") %>"  
		+ timeCardZeroSuppress(date.getSeconds());  
	}  
	
	function timeCardZeroSuppress(time) {  
		if (time < 10) {  
			return "0" + time;  
		}  
		return time;  
	}  

	function applicationCheck() {  
		return confirm (getMessage(MSG_REGIST_CONFIRMATION, '<%= vo.getPortalParameter(PortalTimeCardBean.PRM_RECORD_END_STR) %>'));  
	}

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 メッセージ有無に関わらず時刻表示上部にメッセージ表示分の余白を取る-追加　塩見
		// ページ読み込み時にメッセージ有無の確認をしてレイアウトを調整する
		window.addEventListener('DOMContentLoaded', adjustMessageLayout);

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/7 打刻専用ユーザーでログインしたときのメッセージ及びエラーメッセージ表示欄を社員番号検索ボックスの下部に変更-追加　塩見
		/**
		 * 打刻専用画面（専用ユーザーでログイン）のときにメッセージの表示位置を変更する関数
		 */
		function adjustMessageLayout(){
			// 標準機能でのメッセージを取得する
			const msgArea = document.querySelectorAll('.stcCustomMessage');		// メッセージ表示エリア（メッセージとエラーメッセージを囲うdiv）			
			const nomalMsgSpan = document.querySelectorAll('.MessageSpan');		// 通常メッセージ
			const errorMsgSpan = document.querySelectorAll('.ErrorMessageSpan');	// エラーメッセージ
			
			// 打刻専用ユーザーでログインしたときに表示するpタグの取得
			const messageArea_StcCustom = document.getElementById('messageArea_StcCustom');	// 通常メッセージ
			const errorMessageArea_StcCustom = document.getElementById('errorMessageArea_StcCustom');	// エラーメッセージ
			
			//　表示するメッセージを結合して格納する変数
			let combinedNomalMessage = '';	// 通常メッセージ
			let combinedErrorMessage = '';	// エラーメッセージ
					
			// 標準機能のメッセージ表示エリアが取得できたとき、
			// 標準機能のメッセージ表示エリアを非表示、打刻専用ユーザログイン時のメッセージ表示欄（通常メッセージ、エラーメッセージ）を表示にする
			if ( msgArea.length > 0) {
				msgArea.forEach(el => {
					// 標準機能メッセージ欄を非表示にする
					el.style.display = 'none';
				});

				// 通常メッセージがあるとき
				if (nomalMsgSpan.length > 0) {
					// メッセージを結合する
					nomalMsgSpan.forEach(el => {
						if (el.textContent.trim() !== '') {	// 空でない場合
							combinedNomalMessage += el.textContent + '\n';	// 改行を追加して結合
						}
					});
				}
				// 打刻専用ユーザーでログインしたときに表示する欄にメッセージを表示する
				messageArea_StcCustom.textContent = combinedNomalMessage;

				if (errorMsgSpan.length > 0) {
					// エラーメッセージがある場合は、メッセージを結合する
					errorMsgSpan.forEach(el => {
						if (el.textContent.trim() !== '') {	// 空でない場合
							combinedErrorMessage += el.textContent + '\n';	// 改行を追加して結合
						}
					});
				}
				// 打刻専用ユーザーでログインしたときに表示する欄にメッセージを表示する
				errorMessageArea_StcCustom.textContent = combinedErrorMessage;
			}
			<% 
			// 打刻専用ユーザーでないときは打刻専用ユーザーログイン時のメッセージ表示欄を表示しない
			if(!isTimeCardOnlyUser){
			%>
				messageArea_StcCustom.style.display = 'none';	// メッセージ表示エリアを非表示
				errorMessageArea_StcCustom.style.display = 'none';	// エラーメッセージ表示エリアを非表示
			<%
			} %>
			// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/7 打刻専用ユーザーでログインしたときのメッセージ及びエラーメッセージ表示欄を社員番号検索ボックスの下部に変更-追加　塩見

			// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/9/1 出勤・退勤ボタン押下時に社員名をクリアする-追加　塩見
			const txtEmployeeCode = document.getElementById('txtEmployeeCode');  
			const recordEmployeeName = document.getElementById('recordEmployeeName');
			if(txtEmployeeCode.value == ""){
				recordEmployeeName.textContent = '';	// 打刻専用ユーザーの打刻社員名を空欄にする
			}
			// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/9/1 出勤・退勤ボタン押下時に社員名をクリアする-追加　塩見

		}
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 メッセージ有無に関わらず時刻表示上部にメッセージ表示分の余白を取る-追加　塩見
	
	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見
	function clearEmployeeCode() {
		// 社員コードを空欄にする
		document.getElementById('txtEmployeeCode').value = '';  
		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/7 打刻専用ユーザーでログインしたときのメッセージ及びエラーメッセージ表示欄を社員番号検索ボックスの下部に変更-追加　塩見
		const messageArea_StcCustom_idName = ['messageArea_StcCustom', 'errorMessageArea_StcCustom'];
		const recordEmployeeName = document.getElementById('recordEmployeeName');	// 打刻専用ユーザーの打刻社員名		

		if(recordEmployeeName){
			recordEmployeeName.textContent = '';	// 打刻専用ユーザーの打刻社員名を空欄にする
		}

		// メッセージ表示エリアを空欄にする
		messageArea_StcCustom_idName.forEach(idName => {
			const messageArea = document.getElementById(idName);
			if (messageArea) {
				messageArea.textContent = '';	// メッセージエリアを空欄にする
			}
		}); 
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/7 打刻専用ユーザーでログインしたときのメッセージ及びエラーメッセージ表示欄を社員番号検索ボックスの下部に変更-追加　塩見

		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/9/1 一定時間経過後メッセージクリアと併せてボタンを無効にする-追加　塩見
		// 出勤・退勤ボタンを無効にする
		const disabledBtnList = ['btnStart', 'btnEnd'];
		disabledBtnList.forEach(id =>{
			const btn = document.getElementById(id);
			btn.disabled = true;
			btn.classList.add("disabledBtn");
		});
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/9/1 一定時間経過後メッセージクリアと併せてボタンを無効にする-追加　塩見

	}  
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見
	</script>  
	<%  
	}  
	%>  
	</div>

	<script type="text/javascript">
	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/19 打刻専用ユーザーでログインしたときのみ実行する、メッセージのリフレッシュ・特定のクラスをつける処理を追加-追加　塩見
		// 打刻専用ユーザーの場合に適用するクラスのリスト
		const targetList =[
			{ type: "class", selector: 'Header', className: 'stcCustomHeader' },	// ヘッダー
			{ type: "id", selector: 'divTimeCard', className: 'stcCustomTimeCard' },	// 打刻専用ユーザーの打刻画面
			{ type: "class", selector: 'Time', className: 'stcCustomTime' },	//　打刻ボタン・打刻日時テーブル
			{ type: "id", selector: 'btnStart', className: 'stcCustomBtn' },	// 始業ボタン
			{ type: "id", selector: 'btnStart', className: 'stcCustomStartBtn' },	// 始業ボタン
			{ type: "id", selector: 'btnEnd', className: 'stcCustomBtn' },		// 終業ボタン
			{ type: "class", selector: 'Message', className: 'stcCustomMessage' } // メッセージ表示欄（青＋赤）
		];

		/**
		 * クラスの付け外しを行う関数
		 * @param {boolean} flag - trueならクラスを追加、falseならクラスを削除
		 * @param {Array} targetList - 対象の要素とクラス名のリスト
		 */
		function applyClassesByFlag(isTimeCardOnlyUserflag, targetList) {
			// クラスの付け外し処理の関数
			const toggleClass = (el, className) => {
				if (isTimeCardOnlyUserflag) {
				el.classList.add(className);
				} else {
				el.classList.remove(className);
				}
			};
			targetList.forEach(({type, selector, className }) => {
				if (type === "id"){
					const idElement = document.getElementById(selector);
					if (!idElement) return; // 要素が存在しなければスキップ
					
					toggleClass(idElement, className);
				}
				else if (type === "class") {
					const classElements = document.querySelectorAll(`.${selector}`);
					if (!classElements) return; // 要素が存在しなければスキップ

					classElements.forEach(el => toggleClass(el, className));
				}
			});
		}

		/**
		 * 打刻テーブルの列の表示非表示を行う関数
		 * @param {boolean} flag - trueならクラスを追加、falseならクラスを削除
		 */
		function applyTimeCardTableColumnVisibility(flag) {
			const timeCardDateTd = document.querySelector('.TimeCardDateTd'); // 日付の列
			const timeCardTimeTd = document.querySelector('.TimeCardTimeTd'); // 時間の列

			if (!timeCardDateTd || !timeCardTimeTd) return; // 要素が存在しなければスキップ

			if (flag) {
				// 打刻専用ユーザーの場合、日付の列と時間の列を非表示(visibility = hidden)にする
				timeCardDateTd.style.visibility = 'hidden';
				timeCardTimeTd.style.visibility = 'hidden';
			} else {
				// 打刻専用ユーザーでない場合、日付の列と時間の列を表示する
				timeCardDateTd.style.visibility = 'visible';
				timeCardTimeTd.style.visibility = 'visible';
			}
		}

		<% if (isTimeCardOnlyUser) { %>
			// 特定のタグに打刻専用画面のみで使用するクラスを適用
			applyClassesByFlag(true, targetList);
			// 打刻専用ユーザーの場合、打刻テーブルの列の表示非表示を行う
			applyTimeCardTableColumnVisibility(true);

			const buttons = document.querySelectorAll("button");	// 	全てのボタン要素を取得
			let delaySeconds = <%= messageRefleshTime %>; // 実行する秒数
			let timerStarted = false;	// 複数タイマーの開始を防ぐフラグ
						
			const parentElement = document.querySelectorAll('.Message');	// 削除する要素の親要素を取得
			parentElement.forEach(el => {

				// メッセージが出たら指定秒数経過後にリフレッシュする
				if(!timerStarted){
					timerStarted = true;
					// 取得した秒数経過後にリフレッシュ
					setTimeout(clearEmployeeCode, delaySeconds * 1000);
				}

				// メッセージのbrタグを削除する
				const brElements = el.querySelectorAll('br'); // 親要素内のbrタグを取得
				brElements.forEach(br => br.remove()); // 各brタグを削除
			});
			
		<% } else { %>
			// 特定のタグの打刻専用画面のみで使用するクラスを削除
			applyClassesByFlag(false, targetList);
			// 打刻専用ユーザーでない場合、打刻テーブルの列の表示非表示を行う
			applyTimeCardTableColumnVisibility(false);
		<% } %>
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/19 打刻専用ユーザーでログインしたときのみ実行する、メッセージのリフレッシュ・特定のクラスをつける処理を追加-追加　塩見
	
	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 打刻専用ユーザーでログインしたとき出退勤ボタン表示設定が取得できないときはボタンを無効化する処理を追加-追加　塩見
		if(<%= timeButtonViewControlInt %> == 0){
			// 非表示にするボタンのID名の配列
			const disabledBtnList = ['btnStart', 'btnEnd'];
			disabledBtnList.forEach(id =>{
				const btn = document.getElementById(id);	// 
				btn.disabled = true;
				btn.classList.add("disabledBtn");
			});
		}
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 打刻専用ユーザーでログインしたとき出退勤ボタン表示設定が取得できないときはボタンを無効化する処理を追加-追加　塩見

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 エンターキー押下で検索ボタン押下と同様の処理を実行する-追加　塩見
	<%  
	if (isTimeCardOnlyUser) {
	%> 
	const searchBtn = document.getElementById('btnSearchEmployeeInf');	// 検索ボタンを取得
	
	// 社員番号入力欄要素が取得できない場合
	if(inputEle == null ){
		alert("社員番号入力欄が見つかりません。ページをリロードしてください。");
	};

	// 社員番号入力ボックスでエンターキーを押下したときに検索ボタン押下と同様の処理を実行する
	inputEle.addEventListener("keydown",(e) => {
		if(e.key == "Enter"){
			if(searchBtn){
				// 検索ボタンを取得できた時
				searchBtn.click();
			}else{
				// 検索ボタンが取得できないときも、検索ボタンのonclickイベントと同様の処理を実行する
				handleSearch();
			}
			
		}
	});
	<% } %>

	/**
	 * 検索ボタン押下時に実行する処理の関数
	 *
	 * 半角英数字のみを許容するバリデーションチェックを行い、
	 * その後に検索処理を実行する
	 */
	function handleSearch() {
		const value = inputEle.value;
		if (value.length == 0){
			alert('社員コードを入力してください');
			return;
		}else if (!/^[a-zA-Z0-9]+$/.test(value)) {
			alert('半角英数字のみ入力してください');	// アラートを表示

			clearEmployeeCode();	// 社員番号・メッセージのクリア処理
			return;
		}

		// 問題が無い場合は検索処理を実行する
		submitTransfer(event, null, null, new Array( '<%= PortalAction.PRM_PORTAL_BEAN_CLASS_NAME %>','<%= PortalTimeCardBean.class.getName() %>',
					'<%= PortalTimeCardBean.PRM_RECODE_TYPE %>','<%= PortalTimeCardBean.GET_EMPLOYEE_INF %>','txtEmployeeCode',
				 	document.getElementById('txtEmployeeCode').value),'<%= PortalAction.CMD_REGIST %>' );
  	};
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/23 エンターキー押下で検索ボタン押下と同様の処理を実行する-追加　塩見
	</script>