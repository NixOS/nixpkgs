{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "daemonize";
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "bmc";
    repo = "daemonize";
    rev = "release-${version}";
    sha256 = "1e6LZXf/lK7sB2CbXwOg7LOi0Q8IBQNAa4d7rX0Ej3A=";
  };

  meta = with lib; {
    description = "Runs a command as a Unix daemon";
    homepage = "http://software.clapper.org/daemonize/";
    license = licenses.bsd3;
    platforms = with platforms; linux ++ freebsd ++ darwin;
  };
}
