{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, expat
, libmicrohttpd
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "stabber-unstable-${version}";
  version = "2016-11-09";

  src = fetchFromGitHub {
    owner = "boothj5";
    repo = "stabber";
    rev = "ed75087e4483233eb2cc5472dbd85ddfb7a1d4d4";
    sha256 = "1l6cibggi9rx6d26j1g92r1m8zm1g899f6z7n4pfqp84mrfqgz0p";
  };

  preAutoreconf = ''
    mkdir m4
  '';

  buildInputs = [ autoreconfHook pkgconfig glib expat libmicrohttpd ];

  meta = {
    description = "Stubbed XMPP Server";
    homepage = https://github.com/boothj5/stabber;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ hschaeidt ];
  };
}
