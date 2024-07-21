{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "msr-tools";
  version = "1.3";

  src = fetchurl {
    url = "https://01.org/sites/default/files/downloads/msr-tools/${pname}-${version}.zip";
    sha256 = "07hxmddg0l31kjfmaq84ni142lbbvgq6391r8bd79wpm819pnigr";
  };

  nativeBuildInputs = [ unzip ];

  preInstall = ''
    mkdir -p $out/bin
    substituteInPlace Makefile \
      --replace /usr/sbin $out/bin
  '';

  meta = with lib; {
    description = "Tool to read/write from/to MSR CPU registers on Linux";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
