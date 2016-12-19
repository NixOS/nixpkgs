{ stdenv, fetchgit, zlib, libpng, qt4, qmake4Hook, pkgconfig
, withGamepads ? true, SDL # SDL is used for gamepad functionality
}:

assert withGamepads -> (SDL != null);

let
  version = "1.1.0";
  fstat = x: fn: "-D" + fn + "=" + (if x then "ON" else "OFF");
in
with stdenv.lib;
stdenv.mkDerivation rec{
  name = "PPSSPP-${version}";

  src = fetchgit {
    url = "https://github.com/hrydgard/ppsspp.git";
    rev = "8c8e5de89d52b8bcb968227d96cbf049d04d1241";
    fetchSubmodules = true;
    sha256 = "1q21qskzni0nvz2yi2m17gjh4i9nrs2l4fm4y2dww9m29xpvzw3x";
  };

  buildInputs = [ zlib libpng pkgconfig qt4 qmake4Hook ]
                ++ (if withGamepads then [ SDL ] else [ ]);

  qmakeFlags = [ "PPSSPPQt.pro" ];

  preConfigure = "cd Qt";
  installPhase = "mkdir -p $out/bin && cp ppsspp $out/bin";

  meta = {
    homepage = "http://www.ppsspp.org/";
    description = "A PSP emulator, the Qt4 version";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.fuuzetsu maintainers.AndersonTorres ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.cygwin;
  };
}
