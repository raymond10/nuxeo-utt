<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="robots" content="noindex">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Liste des publications des documents de l'UTT">
  <meta name="author" content="Raymond NANEON">
  <title>
     <@block name="title">
     	Nuxeo-utt
     </@block>
  </title>
  
  <!--CSS-->
  <link rel="shortcut icon" href="${skinPath}/image/favicon_nuxeo.ico">
  <link id="bs-css" rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
  <link id="bsmini-css" rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
  <link id="bsdp-css" rel="stylesheet" href="https://eternicode.github.io/bootstrap-datepicker/bootstrap-datepicker/css/datepicker3.css">
  <link id="pure-css" rel="stylesheet" href="${skinPath}/css/pure.css" type="text/css" media="screen" charset="utf-8">
  <link id="maingrid-css" rel="stylesheet" href="${skinPath}/css/main-grid.css" type="text/css" media="screen" charset="utf-8">
  <link id="main-css" rel="stylesheet" href="${skinPath}/css/main.css" type="text/css" media="screen" charset="utf-8">
  <link id="grids-css" rel="stylesheet" href="${skinPath}/css/grids.css" type="text/css" media="screen" charset="utf-8">
  <link id="babyblue-css" rel="stylesheet" href="${skinPath}/css/baby-blue.css" type="text/css" media="screen" charset="utf-8">
  <link id="intranet-css" rel="stylesheet" href="${skinPath}/css/intranets.css" type="text/css" media="screen" charset="utf-8">
  <link rel="alternate" type="application/rss+xml" title="Flux RSS" href="${Context.baseURL}${Context.modulePath}/rss/${index}" />
  <!--SCRIPTS--> 
  <script src="https://cas.utt.fr/iframe/postMessage-resize-iframe-in-parent.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
  <script src="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
  <script src="https://eternicode.github.io/bootstrap-datepicker/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
  <script src="https://eternicode.github.io/bootstrap-datepicker/bootstrap-datepicker/js/locales/bootstrap-datepicker.fr.js" charset="UTF-8"></script>
  <script>
	$(function() {
		$('#createdStart').datepicker({
		    format: "dd-mm-yyyy",
		    startView: 1,
		    language: "fr",
		    todayHighlight: true,
		    autoclose : true,
		    todayBtn: "linked",
		    orientation: "top auto",
		    clearBtn : true
		    });
		$('#createdEnd').datepicker({
		    format: "dd-mm-yyyy",
		    startView: 1,
		    language: "fr",
		    todayHighlight: true,
		    autoclose : true,
		    todayBtn: "linked",
		    orientation: "top auto",
		    clearBtn : true
		    });
		$('#modifiedStart').datepicker({
		    format: "dd-mm-yyyy",
		    startView: 1,
		    language: "fr",
		    todayHighlight: true,
		    autoclose : true,
		    orientation: "top auto",
		    clearBtn : true
		    });
		$('#modifiedEnd').datepicker({
		    format: "dd-mm-yyyy",
		    startView: 1,
		    language: "fr",
		    todayHighlight: true,
		    autoclose : true,
		    todayBtn: "linked",
		    orientation: "top auto",
		    clearBtn : true
		    });
	});
  </script>
</head>
<!--Corps -->
<body>
  <div class="wrap">
    <div id="main-navbar">
      <div id="nuxeo-navbar"><@block name="nuxeo-navbar" /></div>
    </div>
    <div id="main-wrapper">
      <div id="main">
        <div class="main-content">
          <div id="message"><@block name="message">${Context.getProperty('msg')}</@block></div>
          <div id="content"><@block name="content" /></div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
