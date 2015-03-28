{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "daemonize-${version}";
  version = "1.7.5";

  src = fetchurl {
    url    = "https://github.com/bmc/daemonize/archive/release-${version}.tar.gz";
    sha256 = "0sx0k05n8kyn0ma51nkjll8cs1xygmhv4qsyshxxj8apvjw20qk1";
  };

  meta = with stdenv.lib; {
    description = "Runs a command as a Unix daemon";
    homepage    = http://software.clapper.org/daemonize/;
    license     = licenses.bsd3;
    platforms = with platforms; linux ++ freebsd ++ darwin;
  };
}
