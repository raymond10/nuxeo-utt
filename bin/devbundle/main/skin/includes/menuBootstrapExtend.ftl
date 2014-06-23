<#assign index = Context.getProperty("index")>
<#assign siteRoot = Context.getProperty("siteRoot")>
<!-- Static navbar -->
<nav class="navbar navbar-default" role="navigation">
 <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">GEODE</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse">
      <ul class="nav navbar-nav">
          <li><a id="news" href="${Context.baseURL}${Context.modulePath}/news/${index}"><i class="glyphicon glyphicon-info-sign"></i> Nouveaut&eacute;s</a></li>
          <li><a id="tree" href="${Context.baseURL}${Context.modulePath}/tree/${index}"><i class="glyphicon glyphicon-indent-left"></i> Plans</a></li>
          <li><a id="repository" href="${Context.baseURL}${Context.modulePath}/repository/${index}"><i class="glyphicon glyphicon-list"></i> Publications</a></li>
          <li><a id="advancedSearch" href="${Context.baseURL}${Context.modulePath}/advancedSearch/${index}"><i class="glyphicon glyphicon-search"></i> Recherche avanc&eacute;e</a></li>
      </ul>
    </div><!-- /.navbar-collapse -->
 </div>
</nav>
