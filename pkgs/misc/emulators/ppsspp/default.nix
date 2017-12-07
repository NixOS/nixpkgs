{ stdenv, fetchgit, zlib, libpng, qt4, qmake4Hook, pkgconfig
, withGamepads ? true, SDL # SDL is used for gamepad functionality
}:

assert withGamepads -> (SDL != null);

let
  version = "1.3";
  fstat = x: fn: "-D" + fn + "=" + (if x then "ON" else "OFF");
in
with stdenv.lib;
stdenv.mkDerivation rec{
  name = "PPSSPP-${version}";

  src = fetchgit {
    url = "https://github.com/hrydgard/ppsspp.git";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    sha256 = "0l8vgdlw657r8gv7rz8iqa6zd9zrbzw10pwhcnahzil7w9qrd03g";
  };

  buildInputs = [ zlib libpng qt4 ]
                ++ (if withGamepads then [ SDL ] else [ ]);

  nativeBuildInputs = [ pkgconfig qmake4Hook ];

  qmakeFlags = [ "PPSSPPQt.pro" ];

  preConfigure = "cd Qt";
  installPhase = "mkdir -p $out/bin && cp ppsspp $out/bin";

  meta = {
    homepage = http://www.ppsspp.org/;
    description = "A PSP emulator, the Qt4 version";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fuuzetsu AndersonTorres ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.cygwin;
  };
}
