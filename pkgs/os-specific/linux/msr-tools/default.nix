{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "msr-tools-${version}";
  version = "1.3";

  src = fetchurl {
    url = "https://01.org/sites/default/files/downloads/msr-tools/${name}.zip";
    sha256 = "07hxmddg0l31kjfmaq84ni142lbbvgq6391r8bd79wpm819pnigr";
  };

  buildInputs = [ unzip ];

  preInstall = ''
    mkdir -p $out/bin
    substituteInPlace Makefile \
      --replace /usr/sbin $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Tool to read/write from/to MSR CPU registers on Linux";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
