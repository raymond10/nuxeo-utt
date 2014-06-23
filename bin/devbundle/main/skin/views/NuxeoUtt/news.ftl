<@extends src="base.ftl">
<@block name="nuxeo-navbar">
<#include "includes/menuBootstrap.ftl">
</@block>
<@block name="content">
<table class="dataOutput table-condensed table-hover">
    <thead>
        <tr>
            <th></th>
            <th>Titre</th>
            <th>Derni&egrave;re modification</th>
            <th>Auteur</th>
        </tr>
    </thead>
    <tbody>
    <#list result as child>
        <#assign section_path = child.path>
        <#assign section_path = section_path?substring(Context.getProperty("sectionPath")?length, section_path?length)>
        <#if child.type != "Note">
        	<#assign file = child["file:content"]>
        </#if>
        <tr class="dataRowEven">
            <td class="iconColumn"><img src="${Context.baseURL}/${contextPath}${child["common:icon"]}"></td>
            <#if child.isFolder>
            	<td><a href="${Context.baseURL}${Context.modulePath}/repository/${index}/${section_path}">${child.title}</a></td>
            <#else>
            <#if child.type == "Note">
            	<td><a href="${Context.baseURL}${Context.modulePath}/note/${index}/${child.id}">${child.title}</a></td>
            
            <#else>
	            <td>
	            	<a href="${Context.baseURL}${Context.modulePath}/file/${index}/${section_path}">
	            		${child.title}
	            		<img src="${Context.baseURL}${skinPath}/image/download.png">
	            	</a>
	                <#if file.length &gt;999>(${(file.length / 1024)?int} Ko)</#if>
	                <#if file.length &lt;999>(${file.length} B)</#if>
	            </td>
            </#if>
            </#if>
            <td>${child.dublincore.modified.time?datetime?string.long_short}</td>
            <td>${child.dublincore.creator}</td>
        </tr>
    </#list>
    </tbody>
</table>
<div class="icon_rss"><a href="${Context.baseURL}${Context.modulePath}/rss/${index}"><img src="${Context.baseURL}${skinPath}/image/icon_rss.png"></a></div>

</@block>
</@extends>
