{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, libX11
, libXext
, libXi
, libXrandr
, libXrender
, libSM
, libICE
, libXfixes
, libXinerama
, alsa-lib
, fontconfig
, freetype
, libXcursor
}:

stdenv.mkDerivation rec {
  pname = "egalaxtouch";
  version = "2.5.9321";

  src = fetchurl {
    url = "https://www.eeti.com/touch_driver/Linux/20201110/eGTouch_v${version}.L-x.tar.gz";
    sha256 = "sha256:0i2is8ad0y4jx7clh4wyabz4is1k6bx76w90i7ivrqbqhx3iyb67";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    libSM
    libICE
    libXi
    libXrender
    libXrandr
    libXfixes
    libXcursor
    libXinerama
    freetype
    fontconfig
    libXext
    libX11
    alsa-lib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  system = "x86_64-linux";

  installPhase = ''
    mkdir -p $out/bin
    rm -rf ./eGTouch_v${version}.L-x/eGTouch32
    cp -R ./eGTouch_v${version}.L-x/ $out/opt
    # fix the path in the desktop file
    substituteInPlace \
      $out/opt/Rule/eGTouchD.service \
      --replace /usr/bin/ $out/bin/
    # symlink the binary to bin/
    ln -s $out/opt/eGTouch64/eGTouch64withX/eGTouchD $out/bin/eGTouchD
    ln -s $out/opt/eGTouch64/eGTouch64withX/eGTouchU $out/bin/eGTouchU
    ln -s $out/opt/eGTouch64/eGTouch64withX/eCalib $out/bin/eCalib
  '';

  preFixup = ''
    chmod +x $out/opt/eGTouch64/eGTouch64withX/eGTouchD
    chmod +x $out/opt/eGTouch64/eGTouch64withX/eGTouchU
    chmod +x $out/opt/eGTouch64/eGTouch64nonX/eGTouchD
    chmod +x $out/opt/eGTouch64/eGTouch64withX/eCalib
  '';

  meta = with lib; {
    maintainers = with maintainers; [ _0x4A6F ];
    description = "eGalaxTouch driver for X11";
    homepage = https://www.eeti.com/drivers_Linux.html;
    license = licenses.free;
    platforms = platforms.linux; # Probably, works with other unices as well
  };
}
