{ lib
, stdenv
, fetchurl
, gzip
, brotli
}:

stdenv.mkDerivation rec {
  version = "1.2.1";
  pname = "angie-console-light";

  src = fetchurl {
    url = "https://download.angie.software/files/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-bwnVwhcPyEXGzvpXj2bC1WUGtNbBlHpqZibApKtESq8=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ brotli ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/angie-console-light
    mv ./html $out/share/angie-console-light

    mkdir -p $doc/share/doc/angie-console-light
    mv ./LICENSE $doc/share/doc/angie-console-light

    # Create static gzip and brotli files
    find -L $out -type f -regextype posix-extended -iregex '.*\.(html|js|txt)' \
      -exec gzip --best --keep --force {} ';' \
      -exec brotli --best --keep --no-copy-stat {} ';'

    runHook postInstall
   '';

  meta = {
    description = "Console Light is a lightweight, real-time activity monitoring interface";
    homepage    = "https://angie.software/en/console/";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.all;
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
