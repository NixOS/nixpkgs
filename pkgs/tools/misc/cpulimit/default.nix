{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cpulimit-${version}";
  version = "2.4";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/${name}.tar.gz";
    sha256 = "1fr4rgi5vdbjxsn04j99g1qyr7n5169hrv6lp3lli030alvkfbm2";
  };

  buildFlags = with stdenv;
    if isDarwin then "osx"
    else if isFreeBSD then "freebsd"
    else "cpulimit";

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = "http://limitcpu.sourceforge.net/";
    description = "A tool to throttle the CPU usage of programs";
    platforms = with platforms; linux ++ freebsd;
    license = licenses.gpl2;
    maintainers = [maintainers.rycee];
  };
}
