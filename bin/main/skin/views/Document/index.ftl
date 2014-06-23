<@extends src="base.ftl">
<@block name="nuxeo-navbar">
<#include "includes/menuBootstrap.ftl">
</@block>
<@block name="content">
<!--<link rel="stylesheet" href="${skinPath}/css/intranets.css" type="text/css" media="screen" charset="utf-8">-->
<#function get_path doc>
    <#assign rootPath = Context.getProperty("sectionPath")>
    <#assign rootPath = rootPath?substring(0, rootPath?length - 1)>
    <#if doc.path != rootPath>
		<#local section_path = doc.path>
		<#local section_path = section_path?substring(rootPath?length, section_path?length)>
		<#return get_path(doc.parent) + "> <a href=\"" + Context.baseURL + Context.modulePath + "/repository/" + index + section_path + "\">" + doc.title + "</a> ">
    <#else>
		<#return " <a href=\"" + Context.baseURL + Context.modulePath + "/repository/" + index + "/\">" + doc.title + "</a> ">
    </#if>
</#function>

<#function get_date doc modified_date>
    <#list doc.children as child>
		<#if modified_date.time?datetime &lt; child.dublincore.modified.time?datetime>
		    <#local modified_date = child.dublincore.modified>
		</#if>
		<#if doc.isFolder>
		    <#local modified_date = get_date(child, modified_date)>
		</#if>
    </#list>
    <#return modified_date>
</#function>

<div class="fil_ariane">${get_path(Document)}</div>
<#assign flag_row = true>
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
     <#list Document.children?sort_by("dc:title") as child>    
		<#if child.isFolder>
			<#if flag_row>
				<#assign flag_row = false>
	    		<tr class="dataRowEven">
		   	<#else>
				<#assign flag_row = true>
	    		<tr class="dataRowOdd">
	    	</#if>
			<td class="iconColumn"><img src="${Context.baseURL}/${contextPath}${child["common:icon"]}"></td>
		   	<td><a href="${Context.URL}/${child.name}">${child.title}</a></td>
		   	<td>${get_date(child, child.dublincore.modified).time?datetime?string.long_short}</td>
			<td>${child.dublincore.creator}</td>
			</tr>
		</#if>
     </#list>
    
     <#list Document.children?sort_by("modified")?reverse as child>
    	<#if !child.isFolder>
	    	<#if child.type = "Picture">
	    		<#assign file = child["picture:views"][0]["content"]>
	    		<#assign filename = child["picture:views"][0]["filename"]>
	    	<#elseif child.type != "Note">
		    	<#assign file = child["file:content"]>
		    	<#assign filename = file.filename>
	    	</#if>
	    	<#if flag_row>
				<#assign flag_row = false>
	    		<tr class="dataRowEven">
	    	<#else>
				<#assign flag_row = true>
	    		<tr class="dataRowOdd">
	    	</#if>
			<td class="iconColumn"><img src="${Context.baseURL}/${contextPath}${child["common:icon"]}"></td>
		    <td>
		    <#if child.type == "Note">
		    	<a href="${Context.baseURL}${Context.modulePath}/note/${index}/${child.id}">${child.title}</a>
		    <#else>
		    	<#assign section_path = child.path>
		    	<#assign section_path = section_path?substring(Context.getProperty("sectionPath")?length, section_path?length)>
		    	<a href="${Context.baseURL}${Context.modulePath}/file/${index}/${section_path}">
		    		${child.title}
		    		<img src="${Context.baseURL}${skinPath}/image/download.png">
		    	</a>
				<#if file.length &gt;1024>(${(file.length / 1024)?int} Ko)</#if>
				<#if file.length &lt;1024>(${file.length} B)</#if>
			</#if>
		    </td>
		    <td>${get_date(child, child.dublincore.modified).time?datetime?string.long_short}</td>
			<td>${child.dublincore.creator}</td>
	    	</tr>
		</#if>
    </#list>
    </tbody>
</table>
</@block>
</@extends>
