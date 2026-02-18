/*
 * <標準機能切り出し対応>[設定]2025/7/11 ビューワーメニュー追加対応-追加　塩見
 *
 * 親Voクラス
*/
package jp.mosp.time.MViews.vo;

import jp.mosp.time.settings.base.TimeSettingVo;

public class MviewsCommonVo extends TimeSettingVo {

    private static final long serialversionUID = 1L;

    /**
     * 遷移先URL
     */
    private String targetUserId;

    /**
     * メニュー識別子
    */ 
    private String menuIdentifier;

    /**
     * リダイレクト先のURL
    */ 
    private String redirectViewerUrl;

    public MviewsCommonVo() {
        // 処理なし
    }

    // getter・setter
    public String getTargetUserId() {
        return targetUserId;
    }

    public void setTargetUserId(String targetUserId) {
        this.targetUserId = targetUserId;
    }

    public String getMenuIdentifier(){
        return menuIdentifier;
    }

    public void setMenuIdentifier(String menuIdentifier) {
        this.menuIdentifier = menuIdentifier;
    }

    public String getRedirectViewerUrl(){
        return redirectViewerUrl;
    }

    public void setRedirectViewerUrl(String redirectViewerUrl) {
        this.redirectViewerUrl = redirectViewerUrl;
    }
}
