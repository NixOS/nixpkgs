{ stdenv, fetchurl, linuxHeaders } :


stdenv.mkDerivation rec {
  pname = "linuxptp";
  version = "2.0";

  src = fetchurl {
    url = "mirror://sourceforge/linuxptp/${pname}-${version}.tgz";
    sha256 = "0zcw8nllla06451r7bfsa31q4z8jj56j67i07l1azm473r0dj90a";
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
