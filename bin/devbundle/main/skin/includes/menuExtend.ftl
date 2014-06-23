<#assign index = Context.getProperty("index")>
<#assign siteRoot = Context.getProperty("siteRoot")>
<div class="menu">
	<div class="menu_button">
        <div class="menu_image"><img src="${Context.baseURL}${skinPath}/image/icon_info.png"></div>
        <div class="menu_text"><a href="${Context.baseURL}${Context.modulePath}/news/${index}">Nouveaut&eacute;s</a></div>
        <div class="clearer"></div>
    </div>
    <div class="menu_button">
        <div class="menu_image"><img src="${Context.baseURL}${skinPath}/image/icon_directory.png"></div>
        <div class="menu_text"><a href="${Context.baseURL}${Context.modulePath}/tree/${index}">Plan</a></div>
        <div class="clearer"></div>
    </div>
    <div class="menu_button">
        <div class="menu_image"><img src="${Context.baseURL}${skinPath}/image/icon_tree.png"></div>
        <div class="menu_text"><a href="${Context.baseURL}${Context.modulePath}/repository/${index}">Publications</a></div>
        <div class="clearer"></div>
    </div>
	<div class="menu_button">
		<div class="menu_image"><img src="${Context.baseURL}${skinPath}/image/icon_search.png"></div>
		<div class="menu_text"><a href="${Context.baseURL}${Context.modulePath}/advancedSearch/${index}">Recherche avanc&eacute;e</a></div>
		<div class="clearer"></div>
	</div>
	<div class="clearer"></div>
</div>