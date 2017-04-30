{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cpulimit-${version}";
  version = "2.5";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/${name}.tar.gz";
    sha256 = "1w1l3r9ini78s8idxlzmgljpfgl1n4y4qhp3q2s8y6wq4bfx41lp";
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
