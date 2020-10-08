{ stdenv, fetchurl, linuxHeaders } :


stdenv.mkDerivation rec {
  pname = "linuxptp";
  version = "3.1";

  src = fetchurl {
    url = "mirror://sourceforge/linuxptp/${pname}-${version}.tgz";
    sha256 = "0zff502w3nlycgv2ad8cy8nd0hqf34kzpzcygi7prp0lrw8mp3zm";
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
