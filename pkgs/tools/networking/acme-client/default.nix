{ stdenv
, fetchFromGitHub
, autoreconfHook
, bison
, apple_sdk ? null
, libbsd
, libressl
, pkgconfig
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "acme-client";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "graywolf";
    repo = "acme-client-portable";
    rev = "v${version}";
    sha256 = "1p6jbxg00ing9v3jnpvq234w5r2gf8b04k9qm06mn336lcd2lgpl";
  };

  nativeBuildInputs = [ autoreconfHook bison pkgconfig ];
  buildInputs = [ libbsd libressl ] ++ optional stdenv.isDarwin apple_sdk.sdk;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  patches = [ ./limits.h.patch ];

  meta = {
    homepage = "https://github.com/graywolf/acme-client-portable";
    description = "Secure ACME/Let's Encrypt client";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };
}
