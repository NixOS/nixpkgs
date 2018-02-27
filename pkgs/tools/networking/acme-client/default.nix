{ stdenv
, apple_sdk ? null
, cacert
, defaultCaFile ? "${cacert}/etc/ssl/certs/ca-bundle.crt"
, fetchurl
, libbsd
, libressl
, pkgconfig
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "acme-client-${version}";
  version = "0.1.16";

  src = fetchurl {
    url = "https://kristaps.bsd.lv/acme-client/snapshots/acme-client-portable-${version}.tgz";
    sha256 = "00q05b3b1dfnfp7sr1nbd212n0mqrycl3cr9lbs51m7ncaihbrz9";
  };

  buildInputs = [ libbsd libressl pkgconfig ]
    ++ optional stdenv.isDarwin apple_sdk.sdk;

  CFLAGS = "-DDEFAULT_CA_FILE='\"${defaultCaFile}\"'";

  preConfigure = ''
    export PREFIX="$out"
  '';

  meta = {
    homepage = https://kristaps.bsd.lv/acme-client/;
    description = "Secure ACME/Let's Encrypt client";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };
}
