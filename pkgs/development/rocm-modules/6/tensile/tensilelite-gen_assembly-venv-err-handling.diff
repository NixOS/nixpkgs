diff --git a/Tensile/Ops/gen_assembly.sh b/Tensile/Ops/gen_assembly.sh
index 0b21b6c6..609f1dd1 100755
--- a/Tensile/Ops/gen_assembly.sh
+++ b/Tensile/Ops/gen_assembly.sh
@@ -23,6 +23,8 @@
 #
 ################################################################################
 
+set -x
+
 archStr=$1
 dst=$2
 venv=$3
@@ -35,7 +37,13 @@ fi
 
 toolchain=${rocm_path}/llvm/bin/clang++
 
-. ${venv}/bin/activate
+if ! [ -z ${TENSILE_GEN_ASSEMBLY_TOOLCHAIN+x} ]; then
+    toolchain="${TENSILE_GEN_ASSEMBLY_TOOLCHAIN}"
+fi
+
+if [ -f ${venv}/bin/activate ]; then
+    . ${venv}/bin/activate
+fi
 
 IFS=';' read -r -a archs <<< "$archStr"
 
@@ -77,4 +85,6 @@ for arch in "${archs[@]}"; do
     python3 ./ExtOpCreateLibrary.py --src=$dst --co=$dst/extop_$arch.co --output=$dst --arch=$arch
 done
 
-deactivate
+if [ -f ${venv}/bin/activate ]; then
+    deactivate
+fi
