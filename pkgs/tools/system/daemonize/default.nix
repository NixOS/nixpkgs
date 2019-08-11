{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "daemonize-${version}";
  version = "1.7.8";

  src = fetchurl {
    url    = "https://github.com/bmc/daemonize/archive/release-${version}.tar.gz";
    sha256 = "0q2c3i3si3k7wfhl6fyckkmkc81yp67pz52p3ggis79p4nczri10";
  };

  meta = with stdenv.lib; {
    description = "Runs a command as a Unix daemon";
    homepage    = http://software.clapper.org/daemonize/;
    license     = licenses.bsd3;
    platforms = with platforms; linux ++ freebsd ++ darwin;
  };
}
