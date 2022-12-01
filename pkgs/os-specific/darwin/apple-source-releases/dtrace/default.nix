{ appleDerivation, xcbuildHook, CoreSymbolication
, xnu, bison, flex, darling, stdenv, fixDarwinDylibNames }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook flex bison fixDarwinDylibNames ];
  buildInputs = [ CoreSymbolication darling xnu ];
  # -fcommon: workaround build failure on -fno-common toolchains:
  #   duplicate symbol '_kCSRegionMachHeaderName' in: libproc.o dt_module_apple.o
  NIX_CFLAGS_COMPILE = "-DCTF_OLD_VERSIONS -DPRIVATE -DYYDEBUG=1 -I${xnu}/Library/Frameworks/System.framework/Headers -Wno-error=implicit-function-declaration -fcommon";
  NIX_LDFLAGS = "-L./Products/Release";
  xcbuildFlags = [ "-target" "dtrace_frameworks" "-target" "dtrace" ];

  doCheck = false;
  checkPhase = "xcodebuild -target dtrace_tests";

  postPatch = ''
    substituteInPlace dtrace.xcodeproj/project.pbxproj \
      --replace "/usr/sbin" ""
    substituteInPlace libdtrace/dt_open.c \
      --replace /usr/bin/clang ${stdenv.cc.cc}/bin/clang \
      --replace /usr/bin/ld ${stdenv.cc.bintools.bintools}/bin/ld \
      --replace /usr/lib/dtrace/dt_cpp.h $out/include/dt_cpp.h \
      --replace /usr/lib/dtrace $out/lib/dtrace
  '';

  # hack to handle xcbuild's broken lex handling
  preBuild = ''
    pushd libdtrace
    yacc -d dt_grammar.y
    flex -l -d dt_lex.l
    popd

    substituteInPlace dtrace.xcodeproj/project.pbxproj \
      --replace '6EBC9800099BFBBF0001019C /* dt_grammar.y */ = {isa = PBXFileReference; fileEncoding = 30; lastKnownFileType = sourcecode.yacc; name = dt_grammar.y; path = libdtrace/dt_grammar.y; sourceTree = "<group>"; };' '6EBC9800099BFBBF0001019C /* y.tab.c */ = {isa = PBXFileReference; fileEncoding = 30; lastKnownFileType = sourcecode.c.c; name = y.tab.c; path = libdtrace/y.tab.c; sourceTree = "<group>"; };' \
      --replace '6EBC9808099BFBBF0001019C /* dt_lex.l */ = {isa = PBXFileReference; fileEncoding = 30; lastKnownFileType = sourcecode.lex; name = dt_lex.l; path = libdtrace/dt_lex.l; sourceTree = "<group>"; };' '6EBC9808099BFBBF0001019C /* lex.yy.c */ = {isa = PBXFileReference; fileEncoding = 30; lastKnownFileType = sourcecode.c.c; name = lex.yy.c; path = libdtrace/lex.yy.c; sourceTree = "<group>"; };'
  '';

  # xcbuild doesn't support install
  installPhase = ''
    mkdir -p $out

    cp -r Products/Release/usr/include $out/include
    cp scripts/dt_cpp.h $out/include/dt_cpp.h

    mkdir $out/lib
    cp Products/Release/*.dylib $out/lib

    mkdir $out/bin
    cp Products/Release/dtrace $out/bin

    mkdir -p $out/lib/dtrace

    install_name_tool -change $PWD/Products/Release/libdtrace.dylib $out/lib/libdtrace.dylib $out/bin/dtrace
  '';
}
