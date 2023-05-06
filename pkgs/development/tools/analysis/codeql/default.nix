{ lib, stdenv, fetchzip, zlib, xorg, freetype, jdk17, curl }:

stdenv.mkDerivation rec {
  pname = "codeql";
  version = "2.13.0";

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  src = fetchzip {
    url = "https://github.com/github/codeql-cli-binaries/releases/download/v${version}/codeql.zip";
    sha256 = "sha256-K74o/qEC3DeR8lclJpkIXp6cAP6GLkK5QWJ6HzLxE8M=";
  };

  nativeBuildInputs = [
    zlib
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXtst
    xorg.libXrender
    freetype
    jdk17
    stdenv.cc.cc.lib
    curl
  ];

  installPhase = ''
    # codeql directory should not be top-level, otherwise,
    # it'll include /nix/store to resolve extractors.
    mkdir -p $out/{codeql,bin}
    cp -R * $out/codeql/

    ln -sf $out/codeql/tools/linux64/lib64trace.so $out/codeql/tools/linux64/libtrace.so

    sed -i 's%\$CODEQL_DIST/tools/\$CODEQL_PLATFORM/java-aarch64%\${jdk17}%g' $out/codeql/codeql
    sed -i 's%\$CODEQL_DIST/tools/\$CODEQL_PLATFORM/java%\${jdk17}%g' $out/codeql/codeql

    ln -s $out/codeql/codeql $out/bin/
  '';

  meta = with lib; {
    description = "Semantic code analysis engine";
    homepage = "https://codeql.github.com";
    maintainers = [ maintainers.dump_stack ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = licenses.unfree;
  };
}
