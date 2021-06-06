{ lib, stdenv
, fetchurl
, libbsd
, libressl
, pkg-config
}:

with lib;

stdenv.mkDerivation rec {
  pname = "acme-client";
  version = "1.2.0";

  src = fetchurl {
    url = "https://data.wolfsden.cz/sources/acme-client-${version}.tar.xz";
    sha256 = "sha256-fRSYwQmyV0WapjUJNG0UGO/tUDNTGUraj/BWq/a1QTo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libbsd libressl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://sr.ht/~graywolf/acme-client-portable/";
    description = "Secure ACME/Let's Encrypt client";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };
}
