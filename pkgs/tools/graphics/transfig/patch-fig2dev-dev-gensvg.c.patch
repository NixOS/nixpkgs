--- fig2dev/dev/gensvg.c.orig	Wed Jul 23 16:39:14 2003
+++ fig2dev/dev/gensvg.c	Wed Jul 23 16:39:52 2003
@@ -692,16 +692,14 @@
     if (t->angle != 0) {
 	fprintf (tfp, "<g transform=\"translate(%d,%d) rotate(%d)\" >\n",
 		 (int) (t->base_x * mag), (int) (t->base_y * mag), degrees (t->angle));
-	fprintf (tfp, "<text x=\"0\" y=\"0\" fill=\"#%6.6x\"  font-family=\"%s\" 
-		 font-style=\"%s\" font-weight=\"%s\" font-size=\"%d\" text-anchor=\"%s\" >\n",
+	fprintf (tfp, "<text x=\"0\" y=\"0\" fill=\"#%6.6x\"  font-family=\"%s\" font-style=\"%s\" font-weight=\"%s\" font-size=\"%d\" text-anchor=\"%s\" >\n",
 		 rgbColorVal (t->color), family[(int) ceil ((t->font + 1) / 4)],
 		 (t->font % 2 == 0 ? "normal" : "italic"),
 		 (t->font % 4 < 2 ? "normal" : "bold"), (int) (ceil (t->size * 12 * mag)),
 		 anchor[t->type]);
     }
     else
-	fprintf (tfp, "<text x=\"%d\" y=\"%d\" fill=\"#%6.6x\"  font-family=\"%s\" 
-		 font-style=\"%s\" font-weight=\"%s\" font-size=\"%d\" text-anchor=\"%s\" >\n",
+	fprintf (tfp, "<text x=\"%d\" y=\"%d\" fill=\"#%6.6x\"  font-family=\"%s\" font-style=\"%s\" font-weight=\"%s\" font-size=\"%d\" text-anchor=\"%s\" >\n",
 		 (int) (t->base_x * mag), (int) (t->base_y * mag), rgbColorVal (t->color),
 		 family[(int) ceil ((t->font + 1) / 4)],
 		 (t->font % 2 == 0 ? "normal" : "italic"),
