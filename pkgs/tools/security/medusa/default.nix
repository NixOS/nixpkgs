{ lib, stdenv, fetchFromGitHub, pkg-config, freerdp, openssl, libssh2 }:

stdenv.mkDerivation rec {
  pname = "medusa-unstable";
  version = "2021-01-03";

  src = fetchFromGitHub {
    owner = "jmk-foofus";
    repo = "medusa";
    rev = "bdaa2dda92ad3681387a60cc41d3bd9f077360a1";
    sha256 = "1l90p4h5y1qqr2j2qwwr40k38sp79jrbffnl9m3ca2p1qd3mnn12";
  };

  outputs = [ "out" "man" ];

  configureFlags = [ "--enable-module-ssh=yes" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ freerdp openssl libssh2 ];

  meta = with lib; {
    homepage = "https://github.com/jmk-foofus/medusa";
    description = "A speedy, parallel, and modular, login brute-forcer";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ma27 ];
  };
}
