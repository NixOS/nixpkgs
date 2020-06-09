{ stdenv
, fetchzip
, zlib
, xorg
, freetype
, alsaLib
, jdk11
, curl
, lttng-ust
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "codeql";
  version = "2.1.4";

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  src = fetchzip {
    url = "https://github.com/github/codeql-cli-binaries/releases/download/v${version}/codeql.zip";
    sha256 = "0jgwvc9flqdm88q9kknzjs125j9d3j5l5adcpngfy17ljgziy4nn";
  };

  nativeBuildInputs = [
    zlib
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXtst
    xorg.libXrender
    freetype
    alsaLib
    jdk11
    stdenv.cc.cc.lib
    curl
    lttng-ust
    autoPatchelfHook
  ];

  installPhase = ''
    # codeql directory should not be top-level, otherwise,
    # it'll include /nix/store to resolve extractors.
    mkdir -p $out/{codeql,bin}
    cp -R * $out/codeql/

    ln -sf $out/codeql/tools/linux64/lib64trace.so $out/codeql/tools/linux64/libtrace.so

    sed -i 's;"$CODEQL_DIST/tools/$CODEQL_PLATFORM/java/bin/java";"${jdk11}/bin/java";' $out/codeql/codeql

    ln -s $out/codeql/codeql $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Semantic code analysis engine";
    homepage = "https://semmle.com/codeql";
    maintainers = [ maintainers.dump_stack ];
    license = licenses.unfree;
  };
}
