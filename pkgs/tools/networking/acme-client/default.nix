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
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "graywolf";
    repo = "acme-client-portable";
    rev = "v${version}";
    sha256 = "1d9yk87nj5gizkq26m4wqfh4xhlrn5xlfj7mfgvrpsdiwibqxrrw";
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
