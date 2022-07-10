{ lib, stdenv, fetchzip, zlib, xorg, freetype, jdk11, curl }:

stdenv.mkDerivation rec {
  pname = "codeql";
  version = "2.10.0";

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  src = fetchzip {
    url = "https://github.com/github/codeql-cli-binaries/releases/download/v${version}/codeql.zip";
    sha256 = "sha256-kKQsPxyAdtCDV8x6Upl2e3NUzB7I8gMBogPyCfEMLMU=";
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

    # Many extractors use CODEQL_DIST + CODEQL_PLATFORM to resolve Java home
    for path in $out/codeql/tools/{linux,osx}64/java{,-aarch64}; do
      rm -rf "$path"
      ln -s ${jdk11} "$path"
    done

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
