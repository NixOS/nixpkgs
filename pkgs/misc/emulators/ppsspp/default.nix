{ stdenv, fetchgit, zlib, libpng, qt4, pkgconfig
, withGamepads ? true, SDL # SDL is used for gamepad functionality
}:

let
  version = "0.9.9.1";
  fstat = x: fn: "-D" + fn + "=" + (if x then "ON" else "OFF");
in stdenv.mkDerivation {
  name = "PPSSPP-${version}";

  src = fetchgit {
    url = "https://github.com/hrydgard/ppsspp.git";
    sha256 = "0fdbda0b4dfbecacd01850f1767e980281fed4cc34a21df26ab3259242d8c352";
    rev = "bf709790c4fed9cd211f755acaa650ace0f7555a";
    fetchSubmodules = true;
  };

  buildInputs = [ zlib libpng pkgconfig qt4 ]
                ++ (if withGamepads then [ SDL ] else [ ]);

  configurePhase = "cd Qt && qmake PPSSPPQt.pro";
  installPhase = "mkdir -p $out/bin && cp ppsspp $out/bin";

  meta = with stdenv.lib; {
    homepage = "http://www.ppsspp.org/";
    description = "A PSP emulator, the Qt4 version";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.fuuzetsu ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.cygwin;
  };
}