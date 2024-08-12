# A hack to assemble a static v8 library and put it in the 'libv8' output.

mkdir -p "$libv8"/lib
pushd out/Release/obj
find . -path "./torque_*/**/*.o" -or -path "./v8*/**/*.o" | sort -u >files
$AR -cqs $libv8/lib/libv8.a @files
popd

# copy v8 headers
cp -r deps/v8/include $libv8/

# create a pkgconfig file for v8
major=$(grep V8_MAJOR_VERSION deps/v8/include/v8-version.h | cut -d ' ' -f 3)
minor=$(grep V8_MINOR_VERSION deps/v8/include/v8-version.h | cut -d ' ' -f 3)
patch=$(grep V8_PATCH_LEVEL deps/v8/include/v8-version.h | cut -d ' ' -f 3)
mkdir -p $libv8/lib/pkgconfig
cat >$libv8/lib/pkgconfig/v8.pc <<EOF
Name: v8
Description: V8 JavaScript Engine
Version: $major.$minor.$patch
Libs: -L$libv8/lib -lv8 -pthread -licui18n -licuuc
Cflags: -I$libv8/include
EOF
