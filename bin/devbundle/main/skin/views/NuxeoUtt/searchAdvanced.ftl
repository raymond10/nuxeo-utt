<@extends src="base.ftl">
<@block name="nuxeo-navbar">
<#include "includes/menuBootstrapExtend.ftl">
</@block>
<@block name="content">
<!--<div>${query}</div>-->
<#if error != "">  
	<div class="alert alert-danger">   
	  <strong>Erreur<i class="glyphicon glyphicon-warning-sign"></i></strong> ${error}.  
	</div> 
<#else>
<table class="dataOutput table-condensed table-hover">
    <thead>
        <tr>
            <th></th>
            <th>Titre</th>
            <th>Date de cr&eacute;ation</th>
            <th>Derni&egrave;re modification</th>
            <th>Auteur</th>
            <th>Contributeurs</th>
            <th>Dernier contributeur</th>
            <th>Description</th>
            <th>Sujets</th>
            <!--
            <th>Tag</th>
            -->
            <th>Espace de publication</th>
        </tr>
    </thead>
    <tbody>
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
	    	    <td>${child.dublincore.created.time?datetime?string.long_short}</td>
	    	    <td>${child.dublincore.modified.time?datetime?string.long_short}</td>
	    	    <td>${child.dublincore.creator}</td>
	    	    <td>
	    	      <#list child.dublincore.contributors as contributor>
	    	      	<#if (child.dublincore.contributors?size > 1) >
	    	      		<#assign contributeur = contributor+", ">
	    	      		<#assign contributeurs = contributeurs+contributeur>
	    	      	<#else>
	    	      		<#assign contributeur = contributor>
	    	      	</#if>
	    	      	<#if !contributeur?contains(",")>
	    	    	 	${contributeur}
	    	    	 </#if>
	    	      </#list>
	    	      <#if contributeurs != "">
	    	       	${contributeurs?substring(0, contributeurs?last_index_of(","))}
	    	       	<!--On affiche les contributeurs et on vide la variable-->
	    	      	<#assign contributeurs = "">
	    	      </#if>
	    	    </td>
	    	    <td>${child.dublincore.lastContributor}</td>
	    	    <td>${child.dublincore.description}</td>
	    	    <td>
	    	      <#list child.dublincore.subjects as subject>
	    	      	<#if (child.dublincore.subjects?size > 1) >
	    	      		<#assign sujet = subject+", ">
	    	      		<#assign sujets = sujets+sujet>
	    	      	<#else>
	    	      		<#assign sujet = subject>
	    	      	</#if>
	    	      	<#if !sujet?contains(",")>
	    	    	 	${sujet}
	    	    	 </#if> 
	    	      </#list>
	    	      <#if sujets != "">
	    	       	${sujets?substring(0, sujets?last_index_of(","))}
	    	       	<!--On affiche les sujets et on vide la variable-->
	    	      	<#assign sujets = "">
	    	      </#if>
	    	    </td>
	    	    <!--
	    	    <td>${child.tag}</td>
	    	    -->
	    	    <td>
	    	    	<#if parent_section_path == "">
	    	    		<a href="${Context.baseURL}${Context.modulePath}/repository/${index}/">Espaces de publication</a>
	    	    	<#else>
	    	    		<a href="${Context.baseURL}${Context.modulePath}/repository/${index}/${parent_section_path}">${parent_section_path}</a>
	    	    	</#if>
	    	    </td>
		</tr>
		
    </#list>
    </tbody>
</table>
</#if>
</@block>
</@extends>