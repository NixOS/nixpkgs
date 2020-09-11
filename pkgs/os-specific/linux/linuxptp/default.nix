{ stdenv, fetchurl, linuxHeaders } :


stdenv.mkDerivation rec {
  pname = "linuxptp";
  version = "3.0";

  src = fetchurl {
    url = "mirror://sourceforge/linuxptp/${pname}-${version}.tgz";
    sha256 = "11aps4bc0maihldlb2d0yh2fnj6x4vwjad337kszyny74akyqk6p";
  };

  postPatch = ''
    substituteInPlace incdefs.sh --replace \
       '/usr/include/linux/' "${linuxHeaders}/include/linux/"
  '';

  makeFlags = [ "prefix=" ];

  preInstall = ''
    export DESTDIR=$out
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Implementation of the Precision Time Protocol (PTP) according to IEEE standard 1588 for Linux";
    homepage = "http://linuxptp.sourceforge.net/";
    maintainers = [ maintainers.markuskowa ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
