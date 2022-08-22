{ lib, stdenv, fetchFromGitHub, autoreconfHook, perl, withDebug ? false }:

stdenv.mkDerivation rec {
  pname = "tinyproxy";
  version = "1.11.1";

  src = fetchFromGitHub {
    sha256 = "sha256-tipFXh9VG5auWTI2/IC5rwMQFls7aZr6dkzhYTZZkXM=";
    rev = version;
    repo = "tinyproxy";
    owner = "tinyproxy";
  };

  # perl is needed for man page generation.
  nativeBuildInputs = [ autoreconfHook perl ];

  configureFlags = lib.optionals withDebug [ "--enable-debug" ]; # Enable debugging support code and methods.

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://tinyproxy.github.io/";
    description = "A light-weight HTTP/HTTPS proxy daemon for POSIX operating systems";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = [ maintainers.carlosdagos ];
  };
}
