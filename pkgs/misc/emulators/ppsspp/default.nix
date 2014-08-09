{ stdenv, fetchgit, zlib, libpng, qt4, pkgconfig
, withGamepads ? true, SDL # SDL is used for gamepad functionality
}:

let
  version = "0.9.9";
  fstat = x: fn: "-D" + fn + "=" + (if x then "ON" else "OFF");
in stdenv.mkDerivation {
  name = "PPSSPP-${version}";

  src = fetchgit {
    url = "https://github.com/hrydgard/ppsspp.git";
    sha256 = "1m7awac87wrwys22qwbr0589im1ilm0dv30wp945xg30793rivvj";
    rev = "b421e29391b34d997b2c99ce2bdc74a0df5bb472";
    fetchSubmodules = true;
  };

  buildInputs = [ zlib libpng pkgconfig qt4 ]
                ++ (if withGamepads then [ SDL ] else [ ]);

  configurePhase = "cd Qt && qmake PPSSPPQt.pro";
  installPhase = "mkdir -p $out/bin && cp PPSSPPQt $out/bin";

  meta = with stdenv.lib; {
    homepage = "http://www.ppsspp.org/";
    description = "A PSP emulator, the Qt4 version.";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.fuuzetsu ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.cygwin;
  };
}