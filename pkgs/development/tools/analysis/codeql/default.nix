{ lib, stdenv, fetchzip, zlib, xorg, freetype, jdk11, curl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "codeql";
  version = "2.7.5";

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  src = fetchzip {
    url = "https://github.com/github/codeql-cli-binaries/releases/download/v${version}/codeql.zip";
    sha256 = "sha256-qTLpvb0yPB0+hR0Kkb7d3APlwdkkn6uNM0A80nPmjB4=";
  };

  nativeBuildInputs = [
    zlib
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXtst
    xorg.libXrender
    freetype
    jdk11
    stdenv.cc.cc.lib
    curl
  ];

  installPhase = ''
    # codeql directory should not be top-level, otherwise,
    # it'll include /nix/store to resolve extractors.
    mkdir -p $out/{codeql,bin}
    cp -R * $out/codeql/

    ln -sf $out/codeql/tools/linux64/lib64trace.so $out/codeql/tools/linux64/libtrace.so

    sed -i 's%\$CODEQL_DIST/tools/\$CODEQL_PLATFORM/java%\${jdk11}%g' $out/codeql/codeql

    ln -s $out/codeql/codeql $out/bin/
  '';

  meta = with lib; {
    description = "Semantic code analysis engine";
    homepage = "https://codeql.github.com";
    maintainers = [ maintainers.dump_stack ];
    license = licenses.unfree;
  };
}
