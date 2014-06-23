<html>
<head>
  <title>
     <@block name="title">
     Nuxeo-utt
     </@block>
  </title>
  <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
  <link rel="stylesheet" href="${skinPath}/css/intranets.css" type="text/css" media="screen" charset="utf-8">
  <link rel="alternate" type="application/rss+xml" title="Flux RSS" href="${Context.baseURL}${Context.modulePath}/rss/${index}" />
</head>
<body>
  <div id="wrap">
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
