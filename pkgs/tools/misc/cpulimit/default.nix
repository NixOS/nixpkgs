{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cpulimit-${version}";
  version = "2.3";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/${name}.tar.gz";
    sha256 = "192r2ghxyn8dm1la65f685nzsbj3dhdrxx3cv3i6cafygs3dyfa0";
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
