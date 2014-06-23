<@extends src="base.ftl">
<@block name="content">
<#include "includes/menu.ftl">

<table class="dataOutput">
    <thead>
        <tr>
            <th></th>
            <th>Titre</th>
            <th>Derni&egrave;re modification</th>
            <th>Auteur</th>
            <th>Espace de publication</th>
        </tr>
    </thead>
    <#list result as child>
		<#assign section_path = child.path>
		<#if Context.getProperty("sectionPath")?length gt section_path?length>
			<#assign section_path = "">
		<#else>
			<#assign section_path = section_path?substring(Context.getProperty("sectionPath")?length, section_path?length)>
		</#if>
		<#assign parent_section_path = child.parent.path>
		<#if Context.getProperty("sectionPath")?length gt parent_section_path?length>
			<#assign parent_section_path = "">
		<#else>
			<#assign parent_section_path = parent_section_path?substring(Context.getProperty("sectionPath")?length, parent_section_path?length)>
		</#if>
	    <#if child.type == "Picture">
	    	<#assign file = child["picture:views"][0]["content"]>
	    	<#assign filename = child["picture:views"][0]["filename"]>
	    <#else>
	    	<#if child.type != "Note">
		    	<#assign file = child["file:content"]>
		    	<#assign filename = file.filename>
		    </#if>
	    </#if>
		<tr class="dataRowEven">
	    	    <td class="iconColumn"><img src="${Context.baseURL}/${contextPath}${child["common:icon"]}"></td>
	    	    <#if child.isFolder>
	    	    	<td><a href="${Context.baseURL}${Context.modulePath}/repository/${index}/${section_path}">${child.title}</a></td>
	    	    <#else>
	    	    <#if child.type == "Note">
            		<td><a href="${Context.baseURL}${Context.modulePath}/note/${index}/${child.id}">
            			${child.title}
            		</a></td>
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
	    	    <td>
	    	    	<#if parent_section_path == "">
	    	    		<a href="${Context.baseURL}${Context.modulePath}/repository/${index}/">Espaces de publication</a>
	    	    	<#else>
	    	    		<a href="${Context.baseURL}${Context.modulePath}/repository/${index}/${parent_section_path}">${parent_section_path}</a>
	    	    	</#if>
	    	    </td>
		</tr>
		
    </#list>
</table>

</@block>
</@extends>
