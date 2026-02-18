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
buffer       = "16kb"
autoFlush    = "false"
errorPage    = "/jsp/common/error.jsp"
%><%@ page
import = "jp.mosp.framework.base.MospParams"
import = "jp.mosp.framework.base.BaseVo"
import = "jp.mosp.framework.base.TopicPath"
import = "jp.mosp.framework.constant.MospConst"
import = "jp.mosp.framework.utils.TopicPathUtility"
import = "jp.mosp.platform.base.PlatformVo"
%>

<!-- ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
<%@ page import = "jp.mosp.time.utils.TimeUtility" %>
<!-- ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->

<%
MospParams params = (MospParams)request.getAttribute(MospConst.ATT_MOSP_PARAMS);
BaseVo vo = params.getVo();
if (params.getUser() == null) {
	return;
}

// ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 
// 打刻画面表示用ユーザーの場合、非表示に設定する
String displayStyle = "";  
if (TimeUtility.isTimeCardOnlyUser(params)) {  
    displayStyle = "style=\"display: none;\"";  
}  
// ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 

%>

<!-- ▼ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->
<table class="MenuTable" <%= displayStyle %>>
	<tr id="trMainMenu"></tr>
</table>
<div class="MenuTab" id="divSubMenu"  <%= displayStyle %>>
</div>
<div class="TopicPath"  <%= displayStyle %>>
<!-- ▲ 2026年2月17日　<標準機能切り出し対応>[打刻]2025/6/3 打刻機能カスタマイズ-追加　塩見 -->

<%
int i = 0;
for (TopicPath topicPath : params.getTopicPathList()) {
	if (i < params.getTopicPathList().size() - 1) {
		i++;
%>
	<span>
		<a onclick="submitTransfer(event, null, null, null, '<%= topicPath.getCommand() %>')"><%= TopicPathUtility.getTopicPathTitle(params, topicPath) %></a>
	</span>
	&gt;
<%
	} else {
%>
	<span id="now"><%= TopicPathUtility.getTopicPathTitle(params, topicPath) %></span>
<%
	}
}
%>
</div>
