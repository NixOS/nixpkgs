{ lib, stdenv
, fetchurl
, apple_sdk ? null
, libbsd
, libressl
, pkg-config
}:

with lib;

stdenv.mkDerivation rec {
  pname = "acme-client";
  version = "1.1.0";

  src = fetchurl {
    url = "https://data.wolfsden.cz/sources/acme-client-${version}.tar.xz";
    sha256 = "sha256-AYI7WfRTb5R0/hDX5Iqkq5nrLZ4gQecAGObSajSA+vw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libbsd libressl ] ++ optional stdenv.isDarwin apple_sdk.sdk;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://sr.ht/~graywolf/acme-client-portable/";
    description = "Secure ACME/Let's Encrypt client";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };
}
