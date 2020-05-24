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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "graywolf";
    repo = "acme-client-portable";
    rev = "v${version}";
    sha256 = "0ds7lxn08yiq7hap1xh014smjhd4gf9lv9ypfrf1ahqna3s2w7k8";
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
