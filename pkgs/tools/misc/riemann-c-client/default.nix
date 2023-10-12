{ lib, stdenv, fetchFromGitea, autoreconfHook, pkg-config, file , protobufc }:

stdenv.mkDerivation rec {
  pname = "riemann-c-client";
  version = "2.1.1";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "riemann-c-client-${version}";
    sha256 = "sha256-FIhTT57g2uZBaH3EPNxNUNJn9n+0ZOhI6WMyF+xIr/Q=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ file protobufc ];

  preBuild = ''
    make lib/riemann/proto/riemann.pb-c.h
  '';

  meta = with lib; {
    homepage = "https://git.madhouse-project.org/algernon/riemann-c-client";
    description = "A C client library for the Riemann monitoring system";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pradeepchhetri ];
    platforms = platforms.linux;
  };
}
