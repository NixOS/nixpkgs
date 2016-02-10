{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cpulimit-${version}";
  version = "2.2";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/${name}.tar.gz";
    sha256 = "1r19rk2cbyfmgwh3l445fxkn1bmkzyi69dg5dbx4b4mbqjjxlr1z";
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
