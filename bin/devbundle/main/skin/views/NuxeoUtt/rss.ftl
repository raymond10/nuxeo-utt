<#setting locale="fr"/>

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

<?xml version="1.0"?>
<rss version="2.0">
    <channel>
            <title>Intranets</title>
            <link>${Context.baseURL}${Context.modulePath}/rss/${index}</link>
            <description>Liste des documents r&eacute;cemment modifi&eacute;s dans les intranets</description>
			<#assign index = Context.getProperty("index")>
            <#list result as child>
                <item>
                    <#assign section_path = child.path>
                    <#assign section_path = section_path?substring(Context.getProperty("sectionPath")?length, section_path?length)>
                    <title>${child.title}</title>
                    <link>${Context.baseURL}${Context.modulePath}/file/${index}/${section_path}</link>
                    <description>${child.dublincore.description}</description>
                    <pubDate>${get_date(child, child.dublincore.modified).time?datetime?string("EEE, dd MMM yyyy HH:mm:ss")} GMT</pubDate>
                </item>
            </#list>
    </channel>
</rss>