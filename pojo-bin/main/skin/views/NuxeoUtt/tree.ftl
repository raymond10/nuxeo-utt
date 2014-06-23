<@extends src="base.ftl">

    <#macro get_children node name>
	<#assign rootPath = Context.getProperty("sectionPath")>
	<#assign rootPath = rootPath?substring(0, rootPath?length - 1)>
	<#local section_path = node.path>
	<#local section_path = section_path?substring(rootPath?length, section_path?length)>
	<table class="tree" cellspacing="0" cellpadding="3" border="0">
	<tr>
	    <td><img src="${Context.baseURL}/${contextPath}/icons/folder.gif"></td>
	    <td><a href="${Context.baseURL}${Context.modulePath}/repository/${index}${section_path}">${node.title}</a></td>
	</tr>
	<tr>
	    <td></td>
	    <td>
	    <#list node.children as doc>
		<#if doc.isFolder>
		    <#if name == "">
			<#assign chemin = doc.name>
		    <#else>
			<#assign chemin = name + "/" + doc.name>
		    </#if>
		    <@get_children node=doc name=chemin />
		</#if>
	    </#list>
	    </td>
	</tr>
	</table>
    </#macro>

    <@block name="content">
	<#include "includes/menu.ftl">
	<@get_children node=Document name="" />
    </@block>
</@extends>
