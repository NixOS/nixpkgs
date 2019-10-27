{ mkDerivation, lib, fetchurl, qtbase, qttools, qmake }:

let inherit (lib) getDev; in

mkDerivation rec {
  pname = "qt5ct";
  version = "0.41";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1p2p6116wg5bc0hcbi2sygwlgk0g9idxpci0qdh3p4lb1plk0h7j";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  qmakeFlags = [
    "LRELEASE_EXECUTABLE=${getDev qttools}/bin/lrelease"
  ];

  preConfigure = ''
    qmakeFlags+=" PLUGINDIR=$out/$qtPluginPrefix"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Qt5 Configuration Tool";
    homepage = https://www.opendesktop.org/content/show.php?content=168066;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ralith ];
  };
}
