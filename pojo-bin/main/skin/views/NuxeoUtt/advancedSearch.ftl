<@extends src="base.ftl">
<@block name="content">
<#include "includes/menu.ftl">
<h4>Recherche avanc&eacute;e</h4>(impl&eacute;mentation encours...)
<form action="${This.path}/@searchAdvanced" method="get" accept-charset="utf-8">
	Titre : <input name="title" id="query" results="5"> 
	Auteur : <input name="author" id="query" results="5"><br/>
	Description : <input name="description" id="query" results="5">
	Sujet : <input name="subjects" id="query" results="5"><br/>
	Couverture : <input name="coverage" id="query" results="5"><br/>
	Date de cr&eacute;ation : <input type="date" name="created" id="query" results="5">
	Date de modification : <input type="date" name="modified" id="query" results="5"><br/>
	<input type="hidden" name="orderBy" value="dc:modified">
	<input type="hidden" name="index" value="${index}">
	<input type="submit" value="Rechercher">
</form>
</@block>
</@extends>