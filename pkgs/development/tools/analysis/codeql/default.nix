{ lib, stdenv, fetchzip, zlib, xorg, freetype, jdk11, curl, lttng-ust, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "codeql";
  version = "2.8.5";

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  src = fetchzip {
    url = "https://github.com/github/codeql-cli-binaries/releases/download/v${version}/codeql.zip";
    sha256 = "1b3wwj2x77kr9pw4ddxphpxm82b1rgx9jy7x8wb1isbxdnm434hx";
  };

  # needed until codeql/csharp/tools/linux64/libcoreclrtraceptprovider.so updates its liblttng-ust dependency from liblttng-ust.so.0 to liblttng-ust.so.1
  autoPatchelfIgnoreMissingDeps = true;

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
    lttng-ust
    autoPatchelfHook
  ];

  installPhase = ''
    # codeql directory should not be top-level, otherwise,
    # it'll include /nix/store to resolve extractors.
    mkdir -p $out/{codeql,bin}
    cp -R * $out/codeql/

    ln -sf $out/codeql/tools/linux64/lib64trace.so $out/codeql/tools/linux64/libtrace.so

    # many of the codeql extractors use CODEQL_DIST + CODEQL_PLATFORM to
    # resolve java home, so to be able to create databases, we want to make
    # sure that they point somewhere sane/usable since we can not autopatch
    # the codeql packaged java dist, but we DO want to patch the extractors
    # as well as the builders which are ELF binaries for the most part

    rm -rf $out/codeql/tools/linux64/java
    ln -s ${jdk11} $out/codeql/tools/linux64/java

    ln -s $out/codeql/codeql $out/bin/
  '';

  meta = with lib; {
    description = "Semantic code analysis engine";
    homepage = "https://codeql.github.com";
    maintainers = [ maintainers.dump_stack ];
    license = licenses.unfree;
  };
}
