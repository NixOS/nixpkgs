<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file , protobufc }:

stdenv.mkDerivation rec {
  pname = "riemann-c-client";
  version = "1.10.5";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "riemann-c-client-${version}";
    sha256 = "sha256-LuI9XFDPx0qw/+kkpXd0FOMESERAp31R1+ttkGuJnPA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ file protobufc ];

  preBuild = ''
    make lib/riemann/proto/riemann.pb-c.h
  '';

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://git.madhouse-project.org/algernon/riemann-c-client";
=======
    homepage = "https://github.com/algernon/riemann-c-client";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A C client library for the Riemann monitoring system";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pradeepchhetri ];
    platforms = platforms.linux;
  };
}
