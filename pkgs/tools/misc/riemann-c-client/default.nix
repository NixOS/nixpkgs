{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file , protobufc }:

stdenv.mkDerivation rec {
  name = "riemann-c-client-1.10.2";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "${name}";
    sha256 = "185wn6fqgrs16f9c0lkzw14477wmkgandz86h4miw7cgi7ki4l5i";
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
