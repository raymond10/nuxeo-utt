<@extends src="base.ftl">
  <@block name="title">Intranets</@block>
  <@block name="content">
    Choisissez votre intranet :
    <#assign paths = Context.getProperty("paths")>
    <ul>
    	<#assign index = 0>
	    <#list paths as path>
			<li><a href="${Context.baseURL}${Context.modulePath}/repository/${index}">${path}</a></li>
			<#assign index = index + 1>    
		</#list>
	</ul>
  </@block>
</@extends>
