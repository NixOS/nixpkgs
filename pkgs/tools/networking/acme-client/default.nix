{ stdenv
, fetchurl
, apple_sdk ? null
, libbsd
, libressl
, pkgconfig
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "acme-client";
  version = "1.0.1";

  src = fetchurl {
    url = "https://data.wolfsden.cz/sources/acme-client-${version}.tar.xz";
    sha256 = "0gmdvmyw8a61w08hrxllypf7rpnqg0fxipbk3zmvsxj7m5i6iysj";
  };

  nativeBuildInputs = [ pkgconfig ];
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
