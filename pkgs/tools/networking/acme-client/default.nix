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
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "graywolf";
    repo = "acme-client-portable";
    rev = "v${version}";
    sha256 = "1yq2lkrnjwjs0h9mijqysnjmr7kp4zcq1f4cxr9n1db7pw8446xb";
  };

  nativeBuildInputs = [ autoreconfHook bison pkgconfig ];
  buildInputs = [ libbsd libressl ] ++ optional stdenv.isDarwin apple_sdk.sdk;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://github.com/graywolf/acme-client-portable";
    description = "Secure ACME/Let's Encrypt client";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };
}
