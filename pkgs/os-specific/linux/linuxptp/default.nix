{ lib, stdenv, fetchurl, linuxHeaders } :


stdenv.mkDerivation rec {
  pname = "linuxptp";
  version = "4.2";

  src = fetchurl {
    url = "mirror://sourceforge/linuxptp/${pname}-${version}.tgz";
    hash = "sha256-cOOOXSdk4CF0Q9pvFOiEb+QBpHIpOsE42EGcB6ZlRHo=";
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

  meta = with lib; {
    description = "Implementation of the Precision Time Protocol (PTP) according to IEEE standard 1588 for Linux";
    homepage = "https://linuxptp.sourceforge.net/";
    maintainers = [ maintainers.markuskowa ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
