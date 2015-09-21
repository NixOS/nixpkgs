{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "daemonize-${version}";
  version = "1.7.6";

  src = fetchurl {
    url    = "https://github.com/bmc/daemonize/archive/release-${version}.tar.gz";
    sha256 = "07yv82mkhc57vnawwldqcy64c5yqyh817gksd3b4rgavbsp1fmwd";
  };

  meta = with stdenv.lib; {
    description = "Runs a command as a Unix daemon";
    homepage    = http://software.clapper.org/daemonize/;
    license     = licenses.bsd3;
    platforms = with platforms; linux ++ freebsd ++ darwin;
  };
}
