/*
 * MosP - Mind Open Source Project
 * Copyright (C) esMind, LLC  https://www.e-s-mind.com/
 * 
 * This program is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License
 * as published by the Free Software Foundation, either version 3
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package jp.mosp.time.portal.bean.impl;

import java.util.Date;

import jp.mosp.framework.base.MospException;
import jp.mosp.framework.utils.DateUtility;
import jp.mosp.platform.bean.human.HumanReferenceBeanInterface;
import jp.mosp.platform.bean.portal.PortalBeanInterface;
import jp.mosp.platform.bean.portal.impl.PortalBean;
import jp.mosp.platform.utils.PfMessageUtility;
import jp.mosp.platform.utils.PfNameUtility;
import jp.mosp.time.bean.ApplicationReferenceBeanInterface;
import jp.mosp.time.bean.RequestUtilBeanInterface;
import jp.mosp.time.bean.TimeMasterBeanInterface;
import jp.mosp.time.bean.TimeRecordBeanInterface;
import jp.mosp.time.bean.TimeRecordReferenceBeanInterface;
import jp.mosp.time.bean.TimeSettingReferenceBeanInterface;
import jp.mosp.time.bean.WorkTypeReferenceBeanInterface;
import jp.mosp.time.bean.impl.TimeRecordBean;
import jp.mosp.time.constant.TimeConst;
import jp.mosp.time.dto.settings.TimeRecordDtoInterface;
import jp.mosp.time.entity.ApplicationEntity;
import jp.mosp.time.entity.RequestEntityInterface;
import jp.mosp.time.entity.WorkTypeEntityInterface;
import jp.mosp.time.utils.TimeMessageUtility;
import jp.mosp.time.utils.TimeUtility;

/**
 * ポータル用タイムカード処理クラス。<br>
 */
public class PortalTimeCardBean extends PortalBean implements PortalBeanInterface {
	
	/**
	 * パス(ポータル用打刻機能JSP)。
	 */
	protected static final String	PATH_PORTAL_VIEW	= "/jsp/time/portal/portalTimeCard.jsp";
	
	/**
	 * パス(ポータル用打刻機能JS)。
	 */
	public static final String		JS_TIME				= "jsTime";
	
	/**
	 * ポータルパラメータキー(始業)。
	 */
	public static final String		RECODE_START_WORK	= "StartWork";
	
	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	/**
	 * ポータルパラメータキー(始業：社員指定)。
	 */
	public static final String RECODE_START_WORK_FOR_EMPLOYEE = "StartWorkForEmployee";
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->

	/**
	 * ポータルパラメータキー(終業)。
	 */
	public static final String		RECODE_END_WORK		= "EndWork";
	
	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	/**
	 * ポータルパラメータキー(終業：社員指定)。
	 */
	public static final String RECODE_END_WORK_FOR_EMPLOYEE = "EndWorkForEmployee";
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->

	/**
	 * ポータルパラメータキー(休憩入)。
	 */
	public static final String		RECODE_START_REST	= "StartRest";
	
	/**
	 * ポータルパラメータキー(休憩戻)。
	 */
	public static final String		RECODE_END_REST		= "EndRest";
	
	/**
	 * ポータルパラメータキー(定時終業)。
	 */
	public static final String		RECODE_REGULAR_END	= "RegularEnd";
	
	/**
	 * ポータルパラメータキー(残業有終業)。
	 */
	public static final String		RECODE_OVER_END		= "OverEnd";
	
	/**
	 * ポータルパラメータキー(出勤)。
	 */
	public static final String		RECODE_REGULAR_WORK	= "RegularWork";
	
	/**
	 * パラメータキー(押されたボタンの値)。
	 */
	public static final String		PRM_RECODE_TYPE		= "RecodeType";
	
	/**
	 * パラメータキー(ポータル出退勤ボタン表示)。
	 */
	public static final String		PRM_TIME_BUTTON		= "TimeButton";
	
	/**
	 * パラメータキー(ポータル休憩ボタン表示)。
	 */
	public static final String		PRM_REST_BUTTON		= "RestButton";

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 社員検索の値によって打刻表示を変更-追加　塩見 -->
	/**
	 * パラメータキー(ポータル出退勤ボタン表示)。
	 */
	public static final String PRM_TIME_BUTTON_FOR_SEARCH_EMPLOYEE = "TimeButtonForEmployee";

	/**
	 * パラメータキー(ポータル休憩ボタン表示)。
	 */
	public static final String PRM_REST_BUTTON_FOR_SEARCH_EMPLOYEE = "RestButtonForEmployee";
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 社員検索の値によって打刻表示を変更-追加　塩見 -->
	
	/**
	 * パラメータキー(終業打刻時メッセージ文字列)。
	 */
	public static final String		PRM_RECORD_END_STR	= "RecordEndStr";
	
	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	/**
	 * パラメータキー(社員情報検索)。
	 */
	public static final String GET_EMPLOYEE_INF = "EmpInf";

	/**
	 * パラメータキー(社員コード)。
	 */
	public static final String PRM_EMPLOYEE_CODE = "EmployeeCode";

	/**
	 * パラメータキー(打刻社員名)。
	 */
	public static final String PRM_RECORD_EMPLOYEE_NAME = "RecordEmployeeName";

	/**
	 * 人事マスタ参照処理。<br>
	 */
	protected HumanReferenceBeanInterface humanRefer;
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	
	/**
	 * {@link PortalBean#PortalBean()}を実行する。<br>
	 */
	public PortalTimeCardBean() {
		super();
	}
	
	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	@Override
	public void initBean() throws MospException {
		// Beanを準備
		humanRefer = createBeanInstance(HumanReferenceBeanInterface.class);
	}
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	
	@Override
	public void show() throws MospException {
		// 勤怠一覧が利用できない場合
		if (TimeUtility.isAttendanceListAvailable(mospParams) == false) {
			// 処理無し
			return;
		}
		// ポータル用タイムカードを表示
		showPortalTimeCard();
	}
	
	@Override
	public void regist() throws MospException {
		// VOから値を受け取り変数に詰める
		String recodeType = getPortalParameter(PRM_RECODE_TYPE);
		// コマンド毎の処理
		if (recodeType.equals(RECODE_START_WORK)) {
			// 出勤
			recordStartWork();
			// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
		} else if (recodeType.equals(RECODE_START_WORK_FOR_EMPLOYEE)) {
			// 出勤(社員指定)
			recordStartWorkForEmployee();
			// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
		} else if (recodeType.equals(RECODE_END_WORK)) {
			// 退勤
			recordEndWork();
			// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
		} else if (recodeType.equals(RECODE_END_WORK_FOR_EMPLOYEE)) {
			// 退勤(社員指定)
			recordEndWorkForEmployee();
			// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
		} else if (recodeType.equals(RECODE_START_REST)) {
			// 休憩入
			recordStartRest();
		} else if (recodeType.equals(RECODE_END_REST)) {
			// 休憩戻
			recordEndRest();
		} else if (recodeType.equals(RECODE_REGULAR_END)) {
			// 定時終業
			recordRegularEnd();
		} else if (recodeType.equals(RECODE_OVER_END)) {
			// 残業有終業
			recordOverEnd();
		} else if (recodeType.equals(RECODE_REGULAR_WORK)) {
			// 出勤
			recordRegularWork();
			// ▼ 2025年6月3日 打刻機能カスタマイズ-追加 塩見
		} else if (recodeType.equals(GET_EMPLOYEE_INF)) {
			// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
			// 社員検索
			searchEmployeeInf();
			// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
		}
	}

	
	/**
	 * ポータル用タイムカードを表示する。<br>
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void showPortalTimeCard() throws MospException {
		// ポータル用JSPパス追加
		addPortalViewList(PATH_PORTAL_VIEW);
		// ポータル用JS
		mospParams.addGeneralParam(JS_TIME, String.valueOf(getSystemTimeAndSecond().getTime()));
		// 対象個人ID(ログインユーザの個人ID)取得
		String personalId = mospParams.getUser().getPersonalId();
		// システム日付取得
		Date targetDate = getSystemDate();
		// 設定適用エンティティ取得
		ApplicationEntity application = getApplicationReferenceBean().getApplicationEntity(personalId, targetDate);
		// ポータル出退勤ボタン表示設定取得
		putPortalParameter(PRM_TIME_BUTTON, String.valueOf(application.getPortalTimeButtons()));
		// ポータル休憩ボタン表示設定取得
		putPortalParameter(PRM_REST_BUTTON, String.valueOf(application.getPortalRestButtons()));
		// 終業打刻時メッセージ文字列を設定(申請)
		putPortalParameter(PRM_RECORD_END_STR, PfNameUtility.application(mospParams));
		// ポータル出退勤ボタン表示設定が始業/終業である場合
		if (application.getPortalTimeButtons() == 1) {
			// 勤怠設定エンティティから終業打刻時承認状態設定を取得(デフォルト：申請)
			int endWorkAppliStatus = getTimeSettingRefer().getEntity(application.getTimeSettingDto())
				.getLimit(TimeRecordBean.TYPE_RS_END_WORK_APPLI_STATUS, TimeRecordBean.TYPE_RECORD_APPLY);
			// 終業打刻時承認状態設定が下書である場合
			if (endWorkAppliStatus == TimeRecordBean.TYPE_RECORD_DRAFT) {
				// 終業打刻時メッセージ文字列を設定(下書)
				putPortalParameter(PRM_RECORD_END_STR, PfNameUtility.draft(mospParams));
			}
		}
	}
	
	/**
	 * 打刻専用画面で検索された社員の
	 * ポータル用タイムカードを表示する。<br>
	 * 
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void showPortalTimeCardForSearchEmployee(String personalId) throws MospException {
		// システム日付取得
		Date targetDate = getSystemDate();
		// 設定適用エンティティ取得
		ApplicationEntity application = getApplicationReferenceBean().getApplicationEntity(personalId, targetDate);
		// ポータル出退勤ボタン表示設定取得
		putPortalParameter(PRM_TIME_BUTTON_FOR_SEARCH_EMPLOYEE, String.valueOf(application.getPortalTimeButtons()));
		// ポータル休憩ボタン表示設定取得
		putPortalParameter(PRM_REST_BUTTON_FOR_SEARCH_EMPLOYEE, String.valueOf(application.getPortalRestButtons()));
	}

	/**
	 * 始業を打刻する。<br>
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void recordStartWork() throws MospException {
		TimeRecordDtoInterface dto = getTimeRecordReferenceBean().findForKey(mospParams.getUser().getPersonalId(),
				getSystemDate(), RECODE_START_WORK);
		// 始業打刻
		String recordTime = DateUtility.getStringTimeAndSecond(getTimeRecordBean().recordStartWork());
		// 処理結果確認
		if (mospParams.hasErrorMessage()) {
			if (dto == null) {
				// 打刻失敗メッセージ設定
				PfMessageUtility.addMessageConfirmError(mospParams);
				return;
			}
			// 打刻失敗メッセージ設定
			TimeMessageUtility.addMessageRecordStartTimeFailed(mospParams);
			return;
		}
		// 打刻メッセージ設定
		TimeMessageUtility.addMessageRecordStartWork(mospParams, recordTime);
	}

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	/**
	 * 始業を打刻する(社員指定)。<br>
	 * 
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void recordStartWorkForEmployee() throws MospException {
		// 指定社員のパーソナルIDを取得
		String personalId;
		String employeeCode = mospParams.getRequestParam("txtEmployeeCode");
		personalId = humanRefer.getPersonalId(employeeCode, getSystemDate());
		// 指定社員の社員名を取得
		String employeeName = humanRefer.getHumanName(personalId, getSystemDate());

		// TimeRecordDTOオブジェクトを取得
		TimeRecordDtoInterface dto = getTimeRecordReferenceBean().findForKey(personalId, getSystemDate(),
				RECODE_START_WORK);
		// // 始業打刻
		String recordTime = DateUtility
				.getStringTimeAndSecond(getTimeRecordBean().recordStartWork(personalId, getSystemTimeAndSecond()));

		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 打刻メッセージカスタマイズ-変更　塩見 -->
		// 指定社員の社員名をVoに設定
		putPortalParameter(PRM_RECORD_EMPLOYEE_NAME, employeeName);
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 打刻メッセージカスタマイズ-変更　塩見 -->

		// 処理結果確認
		if (mospParams.hasErrorMessage()) {
			if (dto == null) {
				// 打刻失敗メッセージ設定
				PfMessageUtility.addMessageConfirmError(mospParams);
				return;
			}
			// 打刻失敗メッセージ設定
			TimeMessageUtility.addMessageRecordStartTimeFailed(mospParams);
			return;
		}

		// 打刻メッセージ設定
		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 打刻メッセージカスタマイズ-変更　塩見 -->
		TimeMessageUtility.addMessageRecordStartWorkForEmployee(mospParams, recordTime);
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 打刻メッセージカスタマイズ-変更　塩見 -->
	}
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	
	/**
	 * 終業を打刻する。<br>
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void recordEndWork() throws MospException {
		// 終業打刻
		String recordTime = DateUtility.getStringTimeAndSecond(getTimeRecordBean().recordEndWork());
		// 処理結果確認
		if (mospParams.hasErrorMessage()) {
			// 打刻失敗メッセージ設定
			PfMessageUtility.addMessageConfirmError(mospParams);
			return;
		}
		// 打刻メッセージ設定
		TimeMessageUtility.addMessageRecordEndWork(mospParams, recordTime);
	}

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	/**
	 * 終業を打刻する(社員指定)。<br>
	 * 
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void recordEndWorkForEmployee() throws MospException {
		// 指定社員のパーソナルIDを取得
		String personalId;
		String employeeCode = mospParams.getRequestParam("txtEmployeeCode");
		personalId = humanRefer.getPersonalId(employeeCode, getSystemDate());
		// 指定社員の社員名を取得
		String employeeName = humanRefer.getHumanName(personalId, getSystemDate());

		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/8/29 出勤日・非出勤日に関わらず終業打刻を可能にする-削除　塩見 -->
		// 終業打刻
		// String recordTime = DateUtility
		// 		.getStringTimeAndSecond(getTimeRecordBean().recordEndWork(personalId, getSystemTimeAndSecond()));
		String recordTimeValue = DateUtility.getStringTimeAndSecond(getTimeRecordBean().recordEndWork(personalId, getSystemTimeAndSecond()));
		String recordTime;
		if (recordTimeValue == null || recordTimeValue.isEmpty()) {
			recordTime = "指定日";
		} else {
			recordTime = recordTimeValue;
		}
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/8/29 出勤日・非出勤日に関わらず終業打刻を可能にする-削除　塩見 -->

		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 打刻機能カスタマイズ-追加　塩見 -->
		// 指定社員の社員名をVoに設定
		putPortalParameter(PRM_RECORD_EMPLOYEE_NAME, employeeName);
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 打刻機能カスタマイズ-追加　塩見 -->

		// 処理結果確認
		if (mospParams.hasErrorMessage()) {
			// 打刻失敗メッセージ設定
			PfMessageUtility.addMessageConfirmError(mospParams);
			return;
		}
		// 打刻メッセージ設定
		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 打刻機能カスタマイズ-追加　塩見 -->
		TimeMessageUtility.addMessageRecordEndWorkForEmployee(mospParams, recordTime);
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/8 打刻機能カスタマイズ-追加　塩見 -->
	}
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->

	// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
	/**
	 * 社員情報を取得する。<br>
	 * 
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void searchEmployeeInf() throws MospException {
		// 指定社員のパーソナルIDを取得
		String personalId;
		String employeeCode = mospParams.getRequestParam("txtEmployeeCode");
		personalId = humanRefer.getPersonalId(employeeCode, getSystemDate());
		// 指定社員の社員名を取得
		String employeeName = humanRefer.getHumanName(personalId, getSystemDate());

		// TimeMasterBeanInterfaceの実装を取得
		TimeMasterBeanInterface timeMaster = createBeanInstance(TimeMasterBeanInterface.class);
		// 指定社員の申請エンティティを取得
		RequestUtilBeanInterface requestUtil = createBeanInstance(RequestUtilBeanInterface.class);
		requestUtil.setTimeMaster(timeMaster);
		RequestEntityInterface requestEntity = requestUtil.getRequestEntity(personalId, getSystemDate());
		// 勤務形態コードを取得（カレンダから予定勤務形態を取得）
		String workTypeCode = requestEntity.getWorkType();

		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/8/13 打刻画面の非出勤日の条件にカレンダマスタで振替休日、交替休日を登録していた場合を追加-変更　塩見 -->
		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/10 シフト登録がない場合はメッセージに計画時間を出さない-追加　塩見 -->
		Boolean isWorkTypeCodeNull;
		if (workTypeCode == null || workTypeCode.isEmpty() || workTypeCode.length() == 0 || TimeConst.CODE_HOLIDAY_LEGAL_HOLIDAY.equals(workTypeCode) || TimeConst.CODE_HOLIDAY_PRESCRIBED_HOLIDAY.equals(workTypeCode)) {
			isWorkTypeCodeNull = true;
		} else {
			isWorkTypeCodeNull = false;
		}
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/7/10 シフト登録がない場合はメッセージに計画時間を出さない-追加　塩見 -->
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/8/13 打刻画面の非出勤日の条件にカレンダマスタで振替休日、交替休日を登録していた場合を追加-変更　塩見 -->

		// 勤務形態エンティティを取得
		WorkTypeReferenceBeanInterface workTypeReference = createBeanInstance(WorkTypeReferenceBeanInterface.class);
		WorkTypeEntityInterface workTypeEntity = workTypeReference.getWorkTypeEntity(workTypeCode, getSystemDate());
		// 予定出勤時間・予定退勤時間を取得
		Date scheduledStartTime = workTypeEntity.getStartTime(requestEntity);
		Date scheduledEndTime = workTypeEntity.getEndTime(requestEntity);

		// 指定社員の社員コードをVoに設定
		if (employeeCode != null) {
			putPortalParameter(PRM_EMPLOYEE_CODE, employeeCode);
		}

		// 指定社員の社員名をVoに設定
		putPortalParameter(PRM_RECORD_EMPLOYEE_NAME, employeeName);

		// 社員情報のメッセージ設定
		if (employeeName.equals("")){
			// 該当する社員番号が登録されていない場合、エラーメッセージを出力する
			TimeMessageUtility.addMessageSearchEmployeeNameNull(mospParams);
		} else if (isWorkTypeCodeNull) {
			// 勤務形態コードが取得できない（Nullや空文字）ときは「シフト登録されていない」を、取得できた時は計画時間をメッセージに出力する
			TimeMessageUtility.addMessageSearchEmployeeWorkTypeCodeNull(mospParams);
		} else {
			TimeMessageUtility.addMessageSearchEmployeeInf(mospParams, scheduledStartTime, scheduledEndTime);
		}

		// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 社員検索の値によって打刻表示を変更-変更　塩見 -->
		if (personalId != null && personalId.length() != 0) {
			showPortalTimeCardForSearchEmployee(personalId);
		}
		// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/20 社員検索の値によって打刻表示を変更-変更　塩見 -->
	}
	// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->

	/**
	 * 休憩入を打刻する。<br>
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void recordStartRest() throws MospException {
		// 休憩入打刻
		String recordTime = DateUtility.getStringTimeAndSecond(getTimeRecordBean().recordStartRest());
		// 処理結果確認
		if (mospParams.hasErrorMessage()) {
			// 打刻失敗メッセージ設定
			PfMessageUtility.addMessageConfirmError(mospParams);
			return;
		}
		// 打刻メッセージ設定
		TimeMessageUtility.addMessageRecordStartRest(mospParams, recordTime);
	}
	
	/**
	 * 休憩戻を打刻する。<br>
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void recordEndRest() throws MospException {
		// 休憩戻打刻
		String recordTime = DateUtility.getStringTimeAndSecond(getTimeRecordBean().recordEndRest());
		// 処理結果確認
		if (mospParams.hasErrorMessage()) {
			// 打刻失敗メッセージ設定
			PfMessageUtility.addMessageConfirmError(mospParams);
			return;
		}
		// 打刻メッセージ設定
		TimeMessageUtility.addMessageRecordEndRest(mospParams, recordTime);
	}
	
	/**
	 * 定時終業を打刻する。<br>
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void recordRegularEnd() throws MospException {
		// 定時終業打刻
		String recordTime = DateUtility.getStringTimeAndSecond(getTimeRecordBean().recordRegularEnd());
		// 処理結果確認
		if (mospParams.hasErrorMessage()) {
			// 打刻失敗メッセージ設定
			PfMessageUtility.addMessageConfirmError(mospParams);
			return;
		}
		if (!mospParams.getMessageList().isEmpty()) {
			return;
		}
		// 打刻メッセージ設定
		TimeMessageUtility.addMessageRecordRegularEnd(mospParams, recordTime);
	}
	
	/**
	 * 残業有終業を打刻する。<br>
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void recordOverEnd() throws MospException {
		// 定時終業打刻
		getTimeRecordBean().recordOverEnd();
		// 処理結果確認
		if (mospParams.hasErrorMessage()) {
			// 打刻失敗メッセージ設定
			PfMessageUtility.addMessageConfirmError(mospParams);
		}
	}
	
	/**
	 * 出勤を打刻する。<br>
	 * @throws MospException インスタンスの取得及びSQL実行に失敗した場合
	 */
	protected void recordRegularWork() throws MospException {
		// 定時終業打刻
		String recordTime = DateUtility.getStringTimeAndSecond(getTimeRecordBean().recordRegularWork());
		// 処理結果確認
		if (mospParams.hasErrorMessage()) {
			// 打刻失敗メッセージ設定
			PfMessageUtility.addMessageConfirmError(mospParams);
			return;
		}
		// 打刻メッセージ設定
		TimeMessageUtility.addMessageRecordRegularWork(mospParams, recordTime);
	}
	
	/**
	 * 設定適用参照クラスを取得する。<br>
	 * @return 設定適用参照ユーティリティクラス
	 * @throws MospException インスタンスの取得に失敗した場合
	 */
	protected ApplicationReferenceBeanInterface getApplicationReferenceBean() throws MospException {
		return createBeanInstance(ApplicationReferenceBeanInterface.class);
	}
	
	/**
	 * 勤怠設定参照処理を取得する。<br>
	 * @return 勤怠設定参照処理
	 * @throws MospException インスタンスの取得に失敗した場合
	 */
	protected TimeSettingReferenceBeanInterface getTimeSettingRefer() throws MospException {
		return createBeanInstance(TimeSettingReferenceBeanInterface.class);
	}
	
	/**
	 * 打刻クラスを取得する。<br>
	 * @return 打刻クラス
	 * @throws MospException インスタンスの取得に失敗した場合
	 */
	protected TimeRecordBeanInterface getTimeRecordBean() throws MospException {
		return createBeanInstance(TimeRecordBeanInterface.class);
	}
	
	/**
	 * 打刻データ参照クラスを取得する。<br>
	 * @return 打刻データ参照クラス
	 * @throws MospException インスタンスの取得に失敗した場合
	 */
	protected TimeRecordReferenceBeanInterface getTimeRecordReferenceBean() throws MospException {
		return createBeanInstance(TimeRecordReferenceBeanInterface.class);
	}
	
}
