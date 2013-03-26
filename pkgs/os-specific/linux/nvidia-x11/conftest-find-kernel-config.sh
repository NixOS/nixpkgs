diff -Naur NVIDIA-Linux-x86_64-310.32-no-compat32-orig/kernel/conftest.sh NVIDIA-Linux-x86_64-310.32-no-compat32/kernel/conftest.sh
--- NVIDIA-Linux-x86_64-310.32-no-compat32-orig/kernel/conftest.sh	2013-01-14 17:41:17.000000000 -0500
+++ NVIDIA-Linux-x86_64-310.32-no-compat32/kernel/conftest.sh	2013-03-26 11:24:05.902803670 -0400
@@ -1690,7 +1690,7 @@
             rm -f conftest.h
         else
             MAKEFILE=$HEADERS/../Makefile
-            CONFIG=$HEADERS/../.config
+            CONFIG=$OUTPUT/.config
 
             if [ -f $MAKEFILE -a -f $CONFIG ]; then
                 #
