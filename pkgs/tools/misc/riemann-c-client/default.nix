{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file , protobufc }:

stdenv.mkDerivation rec {
  pname = "riemann-c-client";
  version = "1.10.5";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "riemann-c-client-${version}";
    sha256 = "sha256-LuI9XFDPx0qw/+kkpXd0FOMESERAp31R1+ttkGuJnPA=";
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
