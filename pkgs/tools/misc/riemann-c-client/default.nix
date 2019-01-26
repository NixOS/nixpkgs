{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file , protobufc }:

stdenv.mkDerivation rec {
  name = "riemann-c-client-1.10.4";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "${name}";
    sha256 = "01gzqxqm1xvki2vd78c7my2kgp4fyhkcf5j5fmy8z0l93lgj82rr";
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
