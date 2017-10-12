{ stdenv, appleDerivation, xcbuild }:

# TODO: make this the official libutil expression once we've integrated xcbuild in the bootstrap
appleDerivation {
  buildInputs = [ xcbuild ];

  dontUseXcbuild = true;

  prePatch = ''
    substituteInPlace tzlink.c \
      --replace '#include <xpc/xpc.h>' ""
  '';

  buildPhase = ''
    xcodebuild -target util
  '';

  installPhase = ''
    mkdir -p $out/lib $out/include

    cp libutil-*/Build/Products/Release/*.dylib $out/lib
    cp libutil-*/Build/Products/Release/*.h $out/include

    # TODO: figure out how to get this to be right the first time around
    install_name_tool -id $out/lib/libutil.dylib $out/lib/libutil.dylib
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
