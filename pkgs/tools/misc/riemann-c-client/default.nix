{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file , protobufc }:

stdenv.mkDerivation rec {
  name = "riemann-c-client-1.10.1";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "${name}";
    sha256 = "1pzyngvj9aq1w2185qpg6rxrjn406pnpy40bnh4c21fn4ql5kk9p";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ file protobufc ];

  preBuild = ''
    make lib/riemann/proto/riemann.pb-c.h
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/algernon/riemann-c-client;
    description = "A C client library for the Riemann monitoring system";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rickynils pradeepchhetri ];
    platforms = platforms.linux;
  };
}
