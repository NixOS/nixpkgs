{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "time-1.7";
  src = fetchurl {
    url = ftp://ftp.gnu.org/pub/gnu/time/time-1.7.tar.gz;
    sha256 = "0va9063fcn7xykv658v2s9gilj2fq4rcdxx2mn2mmy1v4ndafzp3";
  };
  meta = {
    description = "Command for running programs and summarizing the system resources they use";
  };
}
