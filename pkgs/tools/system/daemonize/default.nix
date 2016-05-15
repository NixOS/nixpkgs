{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "daemonize-${version}";
  version = "1.7.7";

  src = fetchurl {
    url    = "https://github.com/bmc/daemonize/archive/release-${version}.tar.gz";
    sha256 = "01gabcc8m4jkymd31p6v5883ii3g7126cici6rd03maf4jizxjmk";
  };

  meta = with stdenv.lib; {
    description = "Runs a command as a Unix daemon";
    homepage    = http://software.clapper.org/daemonize/;
    license     = licenses.bsd3;
    platforms = with platforms; linux ++ freebsd ++ darwin;
  };
}
