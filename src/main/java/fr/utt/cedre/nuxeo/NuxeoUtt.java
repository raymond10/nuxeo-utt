package fr.utt.cedre.nuxeo;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.nuxeo.common.utils.URIUtils;
import org.nuxeo.ecm.core.api.Blob;
import org.nuxeo.ecm.core.api.ClientException;
import org.nuxeo.ecm.core.api.CoreSession;
import org.nuxeo.ecm.core.api.DocumentModel;
import org.nuxeo.ecm.core.api.DocumentModelList;
import org.nuxeo.ecm.core.api.DocumentRef;
import org.nuxeo.ecm.core.api.IdRef;
import org.nuxeo.ecm.core.api.NuxeoPrincipal;
import org.nuxeo.ecm.core.api.PathRef;
import org.nuxeo.ecm.core.api.model.Property;
import org.nuxeo.ecm.core.api.model.PropertyException;
import org.nuxeo.ecm.core.api.model.impl.primitives.StringProperty;
import org.nuxeo.ecm.core.rest.DocumentRoot;
import org.nuxeo.ecm.platform.ui.web.auth.NXAuthConstants;
import org.nuxeo.ecm.platform.ui.web.auth.NuxeoAuthenticationFilter;
import org.nuxeo.ecm.platform.ui.web.auth.service.PluggableAuthenticationService;
import org.nuxeo.ecm.webengine.WebException;
import org.nuxeo.ecm.webengine.model.WebObject;
import org.nuxeo.ecm.webengine.model.exceptions.IllegalParameterException;
import org.nuxeo.ecm.webengine.model.exceptions.WebResourceNotFoundException;
import org.nuxeo.ecm.webengine.model.exceptions.WebSecurityException;
import org.nuxeo.ecm.webengine.model.impl.ModuleRoot;
import org.nuxeo.runtime.api.Framework;

/**
 * The root entry for the WebEngine module.
 *
 * @author pchevill
 * @modif @author Raymond
 */
@Path("/nuxeo-utt")
@Produces("text/html;charset=UTF-8")
@WebObject(type = "NuxeoUtt")
@SuppressWarnings("all")
public class NuxeoUtt extends ModuleRoot {

    public static final Log log = LogFactory.getLog(NuxeoUtt.class);

    protected String[] sectionPaths;

    protected String siteRoot;

    public static String PROPERTIES = "OSGI-INF/nuxeo-utt.properties";

    public static String SECTION = "section.path";

    public static String ROOT = "site.root";

    public NuxeoUtt() {
        Map<Object, Object> intranetsProperties = new HashMap<Object, Object>();
        Properties p = new Properties();
        URL url = NuxeoUtt.class.getClassLoader().getResource(PROPERTIES);
        InputStream in = null;
        try {
            in = url.openStream();
            p.load(in);
            intranetsProperties.putAll(p);
        } catch (IOException e) {
            throw new Error("Failed to load mime types");
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (Exception e) {
                }
            }
        }
        String sections = (String) intranetsProperties.get(SECTION);
        siteRoot = (String) intranetsProperties.get(ROOT);
        sectionPaths = sections.split(":");
    }

    /**
     * Get repository
     */
    @Path("repository/{index}/")
    public Object getRepository(@PathParam("index") int index) {
        String sectionPath = sectionPaths[index];
        ctx.setProperty("sectionPath", sectionPath);
        ctx.setProperty("index", index);
        ctx.setProperty("siteRoot", siteRoot);
        return new DocumentRoot(ctx, sectionPath);
    }

    /**
     * Get file
     */
    @GET
    @Path("file/{index}/{path:.*}")
    public Object getFile(@PathParam("index") int index,
            @PathParam("path") String path) throws PropertyException,
            ClientException {
        Object requestedObject;
        Property propertyFile = null;
        String requestedFilename = "";
        Blob requestedBlob = null;
        String sectionPath = sectionPaths[index];
        path = sectionPath + path;
        CoreSession session = ctx.getCoreSession();
        DocumentRef docRef = new PathRef(path);
        DocumentModel doc = null;
        ctx.setProperty("sectionPath", sectionPath);
        ctx.setProperty("siteRoot", siteRoot);
        DocumentModelList proxies = session.getProxies(docRef, null);
        if (proxies.size() > 0) {
            doc = proxies.get(0);
        } else {
            doc = session.getDocument(docRef);
        }
        if (doc.getType().equals("Picture")) {
            List<Property> list = (List<Property>) doc.getProperty("picture:views");
            Property property = list.get(0);
            propertyFile = property.get("content");
        } else {
            propertyFile = doc.getProperty("file:content");
        }
        if (propertyFile != null) {
            requestedBlob = (Blob) propertyFile.getValue();
            if (requestedBlob == null) {
                throw new WebResourceNotFoundException("No attached file at "
                        + "file:content");
            }
            requestedFilename = requestedBlob.getFilename();
            if (requestedFilename == null) {
                propertyFile = propertyFile.getParent();
                if (propertyFile.isComplex()) {
                    try {
                        requestedFilename = (String) propertyFile.getValue("filename");
                    } catch (PropertyException e) {
                        requestedFilename = "Unknown";
                    }
                }
            }
            requestedObject = Response.ok(requestedBlob).header(
                    "Content-Disposition",
                    "inline; filename=" + requestedFilename).type(
                    requestedBlob.getMimeType()).build();
            return requestedObject;
        }
        return this;
    }

    /**
     * Get note file
     */
    @GET
    @Path("noteFile/{index}/{path:.*}")
    public Object getNoteFile(@PathParam("index") int index,
            @PathParam("path") String path) throws PropertyException,
            ClientException {
        Object requestedObject;
        Property propertyFile = null;
        String requestedFilename = "";
        String requestedHtml = null;
        String sectionPath = sectionPaths[index];
        path = sectionPath + path;
        CoreSession session = ctx.getCoreSession();
        DocumentRef docRef = new PathRef(path);
        DocumentModel doc = null;
        ctx.setProperty("sectionPath", sectionPath);
        ctx.setProperty("siteRoot", siteRoot);
        DocumentModelList proxies = session.getProxies(docRef, null);
        if (proxies.size() > 0) {
            doc = proxies.get(0);
        } else {
            doc = session.getDocument(docRef);
        }
        if (doc.getType().equals("Note")) {
            StringProperty sp = (StringProperty) doc.getProperty("note:note");
            requestedHtml = (String) sp.getValue();

            String htmlNotePrefix = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
                    + "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
                    + "<html><head>"
                    + "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />"
                    + "<title>"
                    + doc.getName()
                    + "</title> "
                    + "<script src=\"https://cas.utt.fr/iframe/postMessage-resize-iframe-in-parent.js\"></script> </head> <body>\n";
            String htmlNoteSuffix = "\n</body></html>";

            requestedHtml = htmlNotePrefix + requestedHtml + htmlNoteSuffix;

            requestedFilename = doc.getName() + ".html";
            requestedObject = Response.ok(requestedHtml).header(
                    "Content-Disposition",
                    "attachment; filename=" + requestedFilename).type(
                    "text/html").build();
            return requestedObject;

        }
        return this;
    }

    @GET
    @Path("note/{index}/{uid}")
    public Object getNote(@PathParam("index") int index,
            @PathParam("uid") String uid) throws ClientException {
        String sectionPath = sectionPaths[index];
        ctx.setProperty("sectionPath", sectionPath);
        ctx.setProperty("index", index);
        ctx.setProperty("siteRoot", siteRoot);

        CoreSession coreSession = ctx.getCoreSession();
        DocumentRef documentRef = new IdRef(uid);
        DocumentModel document = coreSession.getDocument(documentRef);

        // TODO à supprimer et ajouter dans fil d'ariane
        org.nuxeo.common.utils.Path path = document.getPath();
        path = path.removeFirstSegments(2);
        path = path.removeLastSegments(1);

        System.out.println(path.toString());
        return getView("note").arg("Document", document).arg(
                "parentNavigationPath", path.toString());
    }

    /**
     * @see org.nuxeo.ecm.webengine.model.impl.ModuleRoot#handleError(javax.ws.rs.WebApplicationException)
     */
    @Override
    public Object handleError(WebApplicationException e) {
        if (e instanceof WebSecurityException) {
            CoreSession coreSession = ctx.getCoreSession();
            NuxeoPrincipal user = (NuxeoPrincipal) coreSession.getPrincipal();
            if (user.isAnonymous()) {
                Map<String, String> urlParameters = new HashMap<String, String>();
                urlParameters.put(NXAuthConstants.SECURITY_ERROR, "true");
                urlParameters.put(NXAuthConstants.FORCE_ANONYMOUS_LOGIN, "true");
                if (ctx.getRequest().getAttribute(NXAuthConstants.REQUESTED_URL) != null) {
                    urlParameters.put(
                            NXAuthConstants.REQUESTED_URL,
                            (String) ctx.getRequest().getAttribute(
                                    NXAuthConstants.REQUESTED_URL));
                } else {
                    urlParameters.put(
                            NXAuthConstants.REQUESTED_URL,
                            NuxeoAuthenticationFilter.getRequestedUrl(ctx.getRequest()));
                }
                String baseURL = "";
                try {
                    baseURL = initAuthenticationService().getBaseURL(
                            ctx.getRequest())
                            + NXAuthConstants.LOGOUT_PAGE;
                } catch (ClientException a) {
                    throw WebException.wrap(a);
                }
                ctx.getRequest().setAttribute(
                        NXAuthConstants.DISABLE_REDIRECT_REQUEST_KEY, true);
                baseURL = URIUtils.addParametersToURIQuery(baseURL,
                        urlParameters);
                log.debug("baseURL = " + baseURL);
                ResponseBuilder responseBuilder;
                try {
                    responseBuilder = Response.seeOther(new URI(baseURL));
                } catch (URISyntaxException e2) {
                    throw WebException.wrap(e2);
                }
                Response requestedObject = responseBuilder.build();
                return requestedObject;
            }
        } else if (e instanceof WebResourceNotFoundException) {
            return Response.status(404).entity(
                    getTemplate("error/error_404.ftl")).build();
        }
        return super.handleError(e);
    }

    /**
     * Default view
     */
    @GET
    // @Path("/")
    public Object doGet() {
        List<String> paths = new ArrayList<String>();
        for (String section : sectionPaths) {
            paths.add(section);
        }
        ctx.setProperty("paths", paths);
        ctx.setProperty("siteRoot", siteRoot);
        log.info("Index = " + ctx.getBasePath());
        return getView("index");
    }

    /**
     * search form
     */
    @GET
    @Path("form/{index}/")
    public Object getViewForm(@PathParam("index") int index) {
        ctx.setProperty("index", index);
        ctx.setProperty("siteRoot", siteRoot);
        log.info("Form = " + ctx.getModulePath());
        return getView("form");
    }

    /**
     * Get tree view
     */
    @GET
    @Path("tree/{index}/")
    public Object getViewTree(@PathParam("index") int index) {
        String sectionPath = sectionPaths[index];
        ctx.setProperty("sectionPath", sectionPath);
        ctx.setProperty("index", index);
        ctx.setProperty("siteRoot", siteRoot);
        log.info("Tree = " + new DocumentRoot(ctx, sectionPath).getPath());
        return getView("tree").arg("doc", new DocumentRoot(ctx, sectionPath));
    }

    /**
     * Search result
     */
    @GET
    @Path("@search")
    public Object search() {
        int index = Integer.parseInt(ctx.getRequest().getParameter("index"));
        String sectionPath = sectionPaths[index];
        ctx.setProperty("sectionPath", sectionPath);
        ctx.setProperty("index", index);
        ctx.setProperty("siteRoot", siteRoot);
        String query = ctx.getRequest().getParameter("query");
        if (query == null) {
            String fullText = ctx.getRequest().getParameter("fullText");
            if (fullText == null) {
                throw new IllegalParameterException(
                        "Expecting a query or a fullText parameter");
            }
            String orderBy = ctx.getRequest().getParameter("orderBy");
            String orderClause = "";
            if (orderBy != null) {
                orderClause = " ORDER BY " + orderBy;
            }
            query = "SELECT * FROM Document WHERE (ecm:fulltext = \""
                    + fullText
                    + "\") AND (ecm:isCheckedInVersion = 0) AND (ecm:path STARTSWITH \""
                    + sectionPath
                    + "\") AND (ecm:currentLifeCycleState != 'deleted')"
                    + orderClause;
        }
        try {
            DocumentModelList docs = ctx.getCoreSession().query(query);
            log.info("Search = " + query);
            return getView("search").arg("query", query).arg("result", docs).arg(
                    "error", "");
        } catch (ClientException e) {
            // throw WebException.wrap(e);
            return getView("search").arg("query", query).arg("result", "").arg(
                    "error", e.getLocalizedMessage());
        }
    }

    /**
     * get latests documents
     */
    @GET
    @Path("news/{index}/")
    public Object getNews(@PathParam("index") int index) {
        String sectionPath = sectionPaths[index];
        ctx.setProperty("sectionPath", sectionPath);
        ctx.setProperty("index", index);
        ctx.setProperty("siteRoot", siteRoot);
        String query = "SELECT * FROM Document WHERE (ecm:path STARTSWITH \""
                + sectionPath
                + "\")"
                + " AND (ecm:primaryType = 'File' OR ecm:primaryType = 'Note') AND (ecm:currentLifeCycleState != 'deleted') ORDER BY dc:modified DESC ";
        try {
            DocumentModelList docs = ctx.getCoreSession().query(query, 10);
            log.info("News = " + docs.toArray());
            return getView("news").arg("query", query).arg("result", docs);
        } catch (ClientException e) {
            throw WebException.wrap(e);
        }
    }

    /**
     * rss feed
     */
    @GET
    @Path("rss/{index}/")
    public Object getRSS(@PathParam("index") int index) {
        String sectionPath = sectionPaths[index];
        ctx.setProperty("sectionPath", sectionPath);
        ctx.setProperty("index", index);
        ctx.setProperty("siteRoot", siteRoot);
        String query = "SELECT * FROM Document WHERE (ecm:path STARTSWITH \""
                + sectionPath
                + "\")"
                + " AND (ecm:primaryType = 'File') AND (ecm:currentLifeCycleState != 'deleted') ORDER BY dc:modified DESC ";
        try {
            DocumentModelList docs = ctx.getCoreSession().query(query, 10);
            log.info("Rss = " + docs.toArray());
            return getView("rss").arg("query", query).arg("result", docs);
        } catch (ClientException e) {
            throw WebException.wrap(e);
        }
    }

    // Ajout recherche avancee
    /**
     * @author Raymond Recherche avancee
     */
    @GET
    @Path("advancedSearch/{index}/")
    public Object getViewAdvancedSearch(@PathParam("index") int index) {
        ctx.setProperty("index", index);
        ctx.setProperty("siteRoot", siteRoot);
        log.info("AdvancedSearch = " + ctx.getBasePath());
        return getView("advancedSearch");
    }

    /**
     * Search result
     */
    @GET
    @Path("@searchAdvanced")
    public Object searchAdvanced() {
        int index = Integer.parseInt(ctx.getRequest().getParameter("index"));
        String sectionPath = sectionPaths[index];
        ctx.setProperty("sectionPath", sectionPath);
        ctx.setProperty("index", index);
        ctx.setProperty("siteRoot", siteRoot);
        String query = ctx.getRequest().getParameter("query");
        String titles = null;
        String authors = null;
        String lastContributors = null;
        String subject = null;
        String descriptions = null;
        String contenu = null;
        String filenames = null;
        String created = null;
        String createdStarts = null;
        String createdEnds = null;
        String modified = null;
        String modifiedStarts = null;
        String modifiedEnds = null;
        if (query == null) {
            String title = ctx.getRequest().getParameter("title");
            String author = ctx.getRequest().getParameter("author");
            String lastContributor = ctx.getRequest().getParameter(
                    "lastContributor");
            String description = ctx.getRequest().getParameter("description");
            String subjects = ctx.getRequest().getParameter("subjects");
            String content = ctx.getRequest().getParameter("content");
            String filename = ctx.getRequest().getParameter("filename");
            String createdStart = ctx.getRequest().getParameter("createdStart");
            String createdEnd = ctx.getRequest().getParameter("createdEnd");
            String modifiedStart = ctx.getRequest().getParameter(
                    "modifiedStart");
            String modifiedEnd = ctx.getRequest().getParameter("modifiedEnd");
            if (title != null && !title.equals("")) {
                titles = "dc:title ILIKE '" + title + "%'";
            } else {
                titles = "dc:title IS NOT NULL";
            }
            if (author != null && !author.equals("")) {
                authors = " AND dc:creator ILIKE '" + author + "%'";
            }
            if (lastContributor != null && !lastContributor.equals("")) {
                lastContributors = " AND dc:lastContributor ILIKE '"
                        + lastContributor + "%'";
            }
            if (description != null && !description.equals("")) {
                descriptions = " AND dc:description ILIKE '" + description
                        + "%'";
            }
            if (subjects != null && !subjects.equals("")) {
                subject = " AND dc:subjects = '" + subjects + "'";
            }
            if (content != null && !content.equals("")) {
                contenu = " AND file:content ILIKE '" + content + "%'";
            }
            if (filename != null && !filename.equals("")) {
                filenames = " AND file:filename = '" + filename + "'";
            }
            // Created
            if ((createdStart != null && !createdStart.equals(""))
                    && (createdEnd != null && !createdEnd.equals(""))) {
                created = " AND dc:created BETWEEN DATE '"
                        + EnDate(createdStart) + "' AND DATE '"
                        + EnDate(createdEnd) + "'";
            }
            if ((createdEnd.equals(null) || createdEnd.equals(""))
                    && (createdStart != null && !createdStart.equals(""))) {
                createdStarts = " AND dc:created >= DATE '"
                        + EnDate(createdStart) + "'";
            }
            if ((createdStart.equals(null) || createdStart.equals(""))
                    && (createdEnd != null && !createdEnd.equals(""))) {
                createdEnds = " AND dc:created <= DATE '" + EnDate(createdEnd)
                        + "'";
            }
            // Modified
            if ((modifiedStart != null && !modifiedStart.equals(""))
                    && (modifiedEnd != null && !modifiedEnd.equals(""))) {
                modified = " AND dc:modified BETWEEN DATE '"
                        + EnDate(modifiedStart) + "' AND DATE '"
                        + EnDate(modifiedEnd) + "'";
            }
            if ((modifiedEnd.equals(null) || modifiedEnd.equals(""))
                    && (modifiedStart != null && !modifiedStart.equals(""))) {
                modifiedStarts = " AND dc:modified >= DATE '"
                        + EnDate(modifiedStart) + "'";
            }
            if ((modifiedStart.equals(null) || modifiedStart.equals(""))
                    && (modifiedEnd != null && !modifiedEnd.equals(""))) {
                modifiedEnds = " AND dc:modified <= DATE '"
                        + EnDate(modifiedEnd) + "'";
            }

            String orderBy = ctx.getRequest().getParameter("orderBy");
            String orderClause = "";
            if (orderBy != null) {
                orderClause = " ORDER BY " + orderBy;
            }
            query = "SELECT * FROM Document WHERE ";
            String endQuery = " AND (ecm:isCheckedInVersion = 0) AND (ecm:path STARTSWITH '"
                    + sectionPath
                    + "') "
                    + "AND (ecm:currentLifeCycleState != 'deleted')"
                    + orderClause;
            if (titles != null) {
                query += titles;
            }
            if (authors != null) {
                query += authors;
            }
            if (lastContributors != null) {
                query += lastContributors;
            }
            if (subject != null) {
                query += subject;
            }
            if (descriptions != null) {
                query += descriptions;
            }
            if (contenu != null) {
                query += contenu;
            }
            if (filenames != null) {
                query += filenames;
            }
            if (created != null) {
                query += created;
            } else {
                if (createdEnds == null && createdStarts != null) {
                    query += createdStarts;
                }
                if (createdStarts == null && createdEnds != null) {
                    query += createdEnds;
                }
            }
            if (modified != null) {
                query += modified;
            } else {
                if (modifiedEnds == null && modifiedStarts != null) {
                    query += modifiedStarts;
                }
                if (modifiedStarts == null && modifiedEnds != null) {
                    query += modifiedEnds;
                }
            }
            query += endQuery;
            System.out.println(query);
            log.info("SearchAdvanced = " + query);
        }
        try {
            DocumentModelList docs = ctx.getCoreSession().query(query);
            return getView("searchAdvanced").arg("query", query).arg("result",
                    docs).arg("error", "");
        } catch (ClientException e) {
            // throw WebException.wrap(query, e);
            return getView("searchAdvanced").arg("query", query).arg("result",
                    "").arg("error",
                    e.getLocalizedMessage());
        }
    }

    // Fin recherche avancee

    /**
     * @return
     * @throws ClientException
     */

    protected PluggableAuthenticationService initAuthenticationService()
            throws ClientException {
        PluggableAuthenticationService service = (PluggableAuthenticationService) Framework.getRuntime().getComponent(
                PluggableAuthenticationService.NAME);
        if (service == null) {
            log.error("Unable to get Service "
                    + PluggableAuthenticationService.NAME);
            throw new ClientException(
                    "Can't initialize Nuxeo Pluggable Authentication Service");
        }
        return service;
    }

    protected String EnDate(String date) {
        String myDate = "";
        int fisrt = date.indexOf("-");
        int last = date.lastIndexOf("-");
        String day = date.substring(0, fisrt);
        String year = date.substring(last + 1, date.length());
        String month = date.substring(fisrt, last);
        myDate = year + month + "-" + day;
        return myDate;
    }
}
