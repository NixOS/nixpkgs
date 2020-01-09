{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "cpulimit";
  version = "2.6";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/${pname}-${version}.tar.gz";
    sha256 = "0xf0r6zxaqan1drz61nqf95p2pkiiihpvrjhrr9dx9j3vswyx31g";
  };

  buildFlags = with stdenv; [ (
    if isDarwin then "osx"
    else if isFreeBSD then "freebsd"
    else "cpulimit"
  ) ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://limitcpu.sourceforge.net/;
    description = "A tool to throttle the CPU usage of programs";
    platforms = with platforms; linux ++ freebsd;
    license = licenses.gpl2;
    maintainers = [maintainers.rycee];
  };
}
