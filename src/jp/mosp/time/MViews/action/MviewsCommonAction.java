/**
 * <標準機能切り出し対応>[設定]2025/7/11 ビューワーメニュー追加対応-追加　塩見
 * 
 * 共通Actionクラス
*/
package jp.mosp.time.MViews.action;


import jp.mosp.framework.base.BaseVo;
import jp.mosp.framework.base.MospException;
import jp.mosp.time.MViews.vo.MviewsCommonVo;
import jp.mosp.time.settings.base.TimeSettingAction;

public class MviewsCommonAction extends TimeSettingAction {

    /**
     * 表示コマンド
    */
    // トップページ
    public static final String CMD_SHOW_TOP = "TM6110";

    public MviewsCommonAction(){
        super();
        topicPathCommand = CMD_SHOW_TOP;
    }

    @Override
    protected BaseVo getSpecificVo() {
        return new MviewsCommonVo();
    }

    @Override
    public void action() throws MospException {
        // トップページ
        if (mospParams.getCommand().equals(CMD_SHOW_TOP)) {
            prepareVo();
            show();
        }
    }

    /**
     * 初期表示
     * 
     * ユーザーIdをパスパラメータにし、メニューに応じたページを表示する
     * @throws MospException
     */
    protected void show() throws MospException {
        MviewsCommonVo vo = (MviewsCommonVo) mospParams.getVo();
        if (vo == null) {
            vo = new MviewsCommonVo();
            mospParams.setVo(vo);
        }

        // ユーザーIDパラメータを取得する
        String paramUserId = mospParams.getRequestParam("userId");
        if (paramUserId != null && !paramUserId.isEmpty()) {
            vo.setTargetUserId(paramUserId);
        } else {
            // パラメーターがない場合はログインユーザーIDを使用する
            paramUserId = mospParams.getUser().getAspUserId();
            vo.setTargetUserId(mospParams.getUser().getUserId());
        }
        
        vo.setTxtSearchActivateYear(getStringYear(getSystemDate()));
        vo.setTxtSearchActivateMonth(getStringMonth(getSystemDate()));
        vo.setTxtSearchActivateDay(getStringDay(getSystemDate()));

        initTimeSettingVoFields();
        setTemplateUrl();

        paramUserId = vo.getTargetUserId();

        // 表示するメニューのコマンドを取得する
        String command = mospParams.getCommand();
        String baseUrl;
        
        // XMLから遷移先のURLを取得する
        switch (command) {
            case CMD_SHOW_TOP:
                    baseUrl = mospParams.getApplicationProperty("MviewsTop");
                break;            
            default:
                    baseUrl = mospParams.getApplicationProperty("MviewsTop");
                break;
        }

        String redirectUrl = baseUrl;
        if (paramUserId != null && !paramUserId.isEmpty()) {
            redirectUrl += "?id=" + paramUserId;
        }

        // 別タブで開く遷移先URL
        vo.setRedirectViewerUrl(redirectUrl);

        // 共通JSPに遷移
        mospParams.setArticleUrl("/jsp/time/MViews/commonViews.jsp");
    }

}