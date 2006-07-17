--- fig2dev/fig2dev.h.orig	Thu Dec 19 07:45:28 2002
+++ fig2dev/fig2dev.h	Tue Jan  7 20:08:45 2003
@@ -22,7 +22,6 @@
 #include <sys/file.h>
 #include <signal.h>
 #include <string.h>
-#include <varargs.h>
 #include <pwd.h>
 #include <errno.h>
 #include <time.h>
@@ -210,7 +209,7 @@
 #endif /* MAXPATHLEN */
 #endif /* PATH_MAX */
 
-#if ( !defined(__NetBSD__) && !defined(__DARWIN__))
+#if ( !defined(__NetBSD__) && !defined(__FreeBSD__) && !defined(__DARWIN__))
 extern int		sys_nerr, errno;
 #endif
 
