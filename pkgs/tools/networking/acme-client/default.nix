{ stdenv
, fetchFromGitHub
, autoconf
, automake
, bison
, apple_sdk ? null
, cacert
, defaultCaFile ? "${cacert}/etc/ssl/certs/ca-bundle.crt"
, libbsd
, libressl
, pkgconfig
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "acme-client";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "graywolf";
    repo = "acme-client-portable";
    rev = "v${version}";
    sha256 = "1yq2lkrnjwjs0h9mijqysnjmr7kp4zcq1f4cxr9n1db7pw8446xb";
  };

  buildInputs = [ autoconf automake bison libbsd libressl pkgconfig ]
    ++ optional stdenv.isDarwin apple_sdk.sdk;

  CFLAGS = "-DDEFAULT_CA_FILE='\"${defaultCaFile}\"'";

  preConfigure = ''
    autoreconf --install
    export PREFIX="$out"
  '';

  meta = {
    homepage = "https://github.com/graywolf/acme-client-portable";
    description = "Secure ACME/Let's Encrypt client";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };
}
