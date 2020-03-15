{ stdenv, fetchzip, tar, autoPatchelfHook, libusb1, libX11, libXtst, qtbase, libglvnd }:
stdenv.mkDerivation rec {
  name = "xp-pen-G430";
  version = "20190820";

  src = fetchzip {
    url = "https://download01.xp-pen.com/file/2019/08/Linux%20Beta%20Driver(${version}).zip";
    sha256 = "091kfqxxj90pdmwncgfl8ldi70pdhwryh3cls30654983m8cgnby";
  };

  nativeBuildInputs = [
    tar
    autoPatchelfHook
  ];

  buildInputs = [
    libusb1
    libX11
    libXtst
    qtbase
    libglvnd
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    tar -xzf Linux_Pentablet_V1.3.0.0.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp Linux_Pentablet_V1.3.0.0/Pentablet_Driver Linux_Pentablet_V1.3.0.0/config.xml $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://www.xp-pen.com/download-46.html;
    description = "Driver for the XP-PEN G430 drawing tablet";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Yvar192 ];
  };
}
