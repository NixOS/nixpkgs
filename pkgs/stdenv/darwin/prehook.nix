''
  dontFixLibtool=1
  stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
  xargsFlags=" "
  export MACOSX_DEPLOYMENT_TARGET=10.9
  export SDKROOT=$(/usr/bin/xcrun --sdk macosx10.9 --show-sdk-path 2> /dev/null || true)
  export NIX_CFLAGS_COMPILE+=" --sysroot=/var/empty -idirafter $SDKROOT/usr/include -F$SDKROOT/System/Library/Frameworks -Wno-multichar -Wno-deprecated-declarations"
  export NIX_LDFLAGS_AFTER+=" -L$SDKROOT/usr/lib"
''
