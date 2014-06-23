/**
 *
 */
package fr.utt.cedre.nuxeo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.nuxeo.ecm.core.api.DocumentModel;
import org.nuxeo.ecm.core.api.DocumentRef;
import org.nuxeo.ecm.core.api.PathRef;
import org.nuxeo.ecm.core.rest.DocumentObject;
import org.nuxeo.ecm.webengine.WebException;
import org.nuxeo.ecm.webengine.model.WebContext;

/**
 * @author Raymond NANEON
 *
 *         Class permetant de faire le tri sur les documents supprimés dans les
 *         repositories et arbres
 *
 */
public class DocumentRootUtt extends DocumentObject {

	public static final Log log = LogFactory.getLog(DocumentRootUtt.class);

	/**
	 * @param ctx
	 * @param uri
	 */
	public DocumentRootUtt(WebContext ctx, String uri) {
		this(ctx, new PathRef(uri));
		// TODO Auto-generated constructor stub
		log.info("Context : " + ctx + " Path : " + uri);
	}

	/**
	 * @param ctx
	 * @param root
	 */
	public DocumentRootUtt(WebContext ctx, DocumentRef root) {
		// TODO Auto-generated constructor stub
		try {
			DocumentModel doc = ctx.getCoreSession().getDocument(root);
			log.info("doc.getCurrentLifeCycleState() : "
					+ doc.getCurrentLifeCycleState());
			initialize(ctx, ctx.getModule().getType(doc.getType()), doc);
			setRoot(true);
			ctx.push(this);
		} catch (Exception e) {
			throw WebException.wrap(e);
		}
	}

	/**
	 * @param ctx
	 * @param root
	 */
	public DocumentRootUtt(WebContext ctx, DocumentModel root) {
		// TODO Auto-generated constructor stub
		initialize(ctx, ctx.getModule().getType(root.getType()), root);
		setRoot(true);
		ctx.push(this);
	}

}
