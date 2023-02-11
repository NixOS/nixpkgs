{ lib, stdenv, fetchurl, pkg-config, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib, openssl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "nzbget";
  version = "21.1";

  src = fetchurl {
    url = "https://github.com/nzbget/nzbget/releases/download/v${version}/nzbget-${version}-src.tar.gz";
    sha256 = "sha256-To/BvrgNwq8tajajOjP0Te3d1EhgAsZE9MR5MEMHICU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxml2 ncurses libsigcxx libpar2 gnutls
                  libgcrypt zlib openssl ];

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) nzbget; };

  meta = with lib; {
    homepage = "https://nzbget.net";
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
