<%-- 
    <標準機能切り出し対応>[設定]2025/7/11 ビューワーメニュー追加対応-追加　塩見
 --%>
<%@ page  
language     = "java"  
pageEncoding = "UTF-8"  
buffer       = "256kb"  
autoFlush    = "false"  
errorPage    = "/jsp/common/error.jsp"  
%>

<%@ page  
import = "jp.mosp.framework.base.MospParams"  
import = "jp.mosp.framework.constant.MospConst"
import = "jp.mosp.framework.utils.HtmlUtility"  
import = "jp.mosp.time.MViews.vo.MviewsCommonVo"
%>

<%  
    MospParams params = (MospParams)request.getAttribute(MospConst.ATT_MOSP_PARAMS);

    // Voを取得する
    MviewsCommonVo vo = (MviewsCommonVo) params.getVo();
    
    // 遷移先のURLをVoから取得する
    String redirectUrl = vo.getRedirectViewerUrl(); 

    if(redirectUrl != null && !redirectUrl.isEmpty()){
%> 
    <script>
        // 別タブでビューワーURLを開く
        open('<%= redirectUrl %>');

        // 同じタブでトップページに遷移
        window.location.href = '<%= request.getContextPath() %>/servlet/';
    </script>
<% } else{%>
    <p>遷移先URLが開けません。</p>
<% } %>