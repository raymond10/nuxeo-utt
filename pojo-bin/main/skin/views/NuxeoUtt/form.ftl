<@extends src="base.ftl">
<@block name="content">
<#include "includes/menu.ftl">
<form action="${This.path}/@search" method="get" accept-charset="utf-8">
	<input type="search" name="fullText" id="query" results="5">
	<input type="hidden" name="orderBy" value="dc:modified">
	<input type="hidden" name="index" value="${index}">
	<input type="submit" value="Rechercher">
</form>
</@block>
</@extends>
