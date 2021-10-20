{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file , protobufc }:

stdenv.mkDerivation rec {
  pname = "riemann-c-client";
  version = "1.10.4";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "riemann-c-client-${version}";
    sha256 = "01gzqxqm1xvki2vd78c7my2kgp4fyhkcf5j5fmy8z0l93lgj82rr";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ file protobufc ];

  preBuild = ''
    make lib/riemann/proto/riemann.pb-c.h
  '';

  meta = with lib; {
    homepage = "https://github.com/algernon/riemann-c-client";
    description = "A C client library for the Riemann monitoring system";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pradeepchhetri ];
    platforms = platforms.linux;
  };
}
