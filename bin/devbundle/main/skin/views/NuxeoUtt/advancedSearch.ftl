<@extends src="base.ftl">
<@block name="nuxeo-navbar">
  <#include "includes/menuBootstrapExtend.ftl">
</@block>
<@block name="content">
<form class="pure-form pure-form-stacked" action="${siteRoot}/@searchAdvanced" method="get" accept-charset="utf-8">
	<fieldset>
		<!--<legend>Recherche avanc&eacute;e</legend>-->
			<div class="pure-g">
			   <div class="pure-u-1 pure-u-med-1-3">
				 <label for="Titre">Titre</label>
				 <input type="text" name="title" id="title" results="5" placeholder="le titre du document" required="require">
			   </div>
			   <div class="pure-u-1 pure-u-med-1-3">
			     <label for="Auteur">Auteur</label>
			     <input type="text" name="author" id="author" results="5" placeholder="l'auteur du document">
			   </div>
			   <div class="pure-u-1 pure-u-med-1-3">
			     <label for="Contributeurs">Dernier contributeur</label>
			     <input type="text" name="lastContributor" id="lastContributor" results="5" placeholder="le dernier contributeur du document">
			   </div>
			   <div class="pure-u-1 pure-u-med-1-3">
			     <label for="Description">Description</label>
			     <input type="text" name="description" id="description" results="5" placeholder="la description du document">
			   </div>
			   <div class="pure-u-1 pure-u-med-1-3">
			     <label for="Sujet">Sujet</label>
			     <input type="text" name="subjects" id="subjects" results="5" placeholder="le sujet du document">
			   </div>
			   <!--
			   <div class="pure-u-1 pure-u-med-1-3">
			     <label for="Contenu">Contenu</label>
			     <input type="text" name="content" id="content" results="5" placeholder="le contenu du document">
			   </div>
			   -->
			   <div class="pure-u-1 pure-u-med-1-3">
			     <label for="filename ">Nom du fichier</label>
			     <input type="text" name="filename" id="filename" results="5" placeholder="le fichier lié au document">
			   </div>
			   <div class="pure-u-1 pure-u-med-1-3">
			     <label for="dateCreate">Date de cr&eacute;ation du </label>
			     <div class="span input-daterange input-group" id="created">
				     <input type="text" class="input-sm form-control" name="createdStart" id="createdStart" placeholder="dd-mm-yyy"/>
				     <span class="input-group-addon">au</span>
				     <input type="text" class="input-sm form-control" name="createdEnd" id="createdEnd" placeholder="dd-mm-yyyy"/>
			     </div>
			   </div>
			   <div class="space"></div>
			   <div class="pure-u-1 pure-u-med-1-3">
			     <label for="dateModif">Date de modification du </label>
			     <div class="span input-daterange input-group" id="modified">
				     <input type="text" class="input-sm form-control" name="modifiedStart" id="modifiedStart" placeholder="dd-mm-yyyy"/>
				     <span class="input-group-addon">au</span>
				     <input type="text" class="input-sm form-control" name="modifiedEnd" id="modifiedEnd" placeholder="dd-mm-yyyy"/>
			     </div>
			   </div>
			<input type="hidden" name="orderBy" value="dc:modified">
			<input type="hidden" name="index" value="${index}">
		    </div>
		    <br/>
			<button type="submit" class="btn btn-primary btn-small">Rechercher</button>
	</fieldset>
</form>
</@block>
</@extends>