{ appleDerivation, xcbuildHook, CoreSymbolication
, xnu, bison, flex, darling, stdenv }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook flex bison ];
  buildInputs = [ CoreSymbolication darling ];
  NIX_CFLAGS_COMPILE = "-DCTF_OLD_VERSIONS -DPRIVATE -DYYDEBUG=1 -I${xnu}/Library/Frameworks/System.framework/Headers";
  NIX_LDFLAGS = "-L./Products/Release";
  xcbuildFlags = "-target dtrace";

  patchPhase = ''
    substituteInPlace dtrace.xcodeproj/project.pbxproj --replace "/usr/sbin" ""
    substituteInPlace libdtrace/dt_open.c \
      --replace "/usr/bin/clang" "${stdenv.cc}/bin/cpp" \
      --replace "/usr/bin/ld" "${stdenv.cc}/bin/ld" \
      --replace "/usr/bin/dtrace" $out/lib/dtrace
  '';

  # hack to handle xcbuild's broken lex handling
  preBuild = ''
    cd libdtrace
    yacc -d dt_grammar.y
    flex -l -d dt_lex.l
    cd ..

    substituteInPlace dtrace.xcodeproj/project.pbxproj \
      --replace '6EBC9800099BFBBF0001019C /* dt_grammar.y */ = {isa = PBXFileReference; fileEncoding = 30; lastKnownFileType = sourcecode.yacc; name = dt_grammar.y; path = libdtrace/dt_grammar.y; sourceTree = "<group>"; };' '6EBC9800099BFBBF0001019C /* y.tab.c */ = {isa = PBXFileReference; fileEncoding = 30; lastKnownFileType = sourcecode.c.c; name = y.tab.c; path = libdtrace/y.tab.c; sourceTree = "<group>"; };' \
      --replace '6EBC9808099BFBBF0001019C /* dt_lex.l */ = {isa = PBXFileReference; fileEncoding = 30; lastKnownFileType = sourcecode.lex; name = dt_lex.l; path = libdtrace/dt_lex.l; sourceTree = "<group>"; };' '6EBC9808099BFBBF0001019C /* lex.yy.c */ = {isa = PBXFileReference; fileEncoding = 30; lastKnownFileType = sourcecode.c.c; name = lex.yy.c; path = libdtrace/lex.yy.c; sourceTree = "<group>"; };'
  '';

  # xcbuild doesn't support install
  installPhase = ''
    mkdir -p $out

    cp -r Products/Release/usr $out
    mv $out/usr/* $out
    rmdir $out/usr

    mkdir $out/lib
    cp Products/Release/*.dylib $out/lib

    mkdir $out/bin
    cp Products/Release/dtrace $out/bin

    mkdir -p $out/lib/dtrace
  '';
}
