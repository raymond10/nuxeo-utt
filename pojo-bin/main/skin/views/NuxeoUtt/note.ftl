<@extends src="base.ftl">
<@block name="content">

<#include "includes/menu.ftl">
<#function get_path doc>
    <#assign rootPath = Context.getProperty("sectionPath")>
    <#assign rootPath = rootPath?substring(0, rootPath?length - 1)>
    <#if doc.path != rootPath>
		<#local section_path = doc.path>
		<#local section_path = section_path?substring(rootPath?length, section_path?length)>
		<#if doc.title != Document["title"]>
			<#return get_path(doc.parent) + "> <a href='" + Context.baseURL + Context.modulePath + "/repository/" + index + section_path + "'>" + doc.title + "</a> ">
		<#else>
			<#return get_path(doc.parent) + "> " + doc.title>
		</#if>
    <#else>
		<#return " <a href='" + Context.baseURL + Context.modulePath + "/repository/" + index + "/'>" + doc.title + "</a> ">
    </#if>
</#function>

<#assign section_path = Document.path>
<#if Context.getProperty("sectionPath")?length gt section_path?length>
	<#assign section_path = "">
<#else>
	<#assign section_path = section_path?substring(Context.getProperty("sectionPath")?length, section_path?length)>
</#if>

<div class="fil_ariane" style="float:left;padding-right:10px;">${get_path(Document)}</div>

<div class="download">
	<a href="${Context.baseURL}${Context.modulePath}/noteFile/${index}/${section_path}" title="Télécharger" alt="Télécharger">
		<img src="${Context.baseURL}${skinPath}/image/download.png">
	</a>
</div>


${Document["note:note"]}


</@block>
</@extends>
