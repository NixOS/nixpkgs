{ stdenv, fetchzip, patchelf, libusb1, libX11, libXtst, qt5, libglvnd }:
stdenv.mkDerivation rec {
  name = "xp-pen-G430";
  version = "20190820";

  src = fetchzip {
    url = "https://download01.xp-pen.com/file/2019/08/Linux%20Beta%20Driver(${version}).zip";
    sha256 = "091kfqxxj90pdmwncgfl8ldi70pdhwryh3cls30654983m8cgnby";
  };

  dontConfigure = true;  
  dontBuild = true;

  installPhase = ''
    tar -xzf Linux_Pentablet_V1.3.0.0.tar.gz
    mkdir -p $out/bin
    cp -r Linux_Pentablet_V1.3.0.0/Pentablet_Driver Linux_Pentablet_V1.3.0.0/config.xml $out/bin
  '';

  preFixup = let
    libPath = stdenv.lib.makeLibraryPath [
      libusb1
      libX11
      libXtst
      qt5.qtbase
      libglvnd
      stdenv.cc.cc.lib
      ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/Pentablet_Driver
  '';

  meta = with stdenv.lib; {
    homepage = https://www.xp-pen.com/download-46.html;
    description = "Driver for the XP-PEN G430 drawing tablet";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ Yvar192 ];
  };
}
