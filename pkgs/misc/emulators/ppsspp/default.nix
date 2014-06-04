{ stdenv, fetchgit, zlib, libpng, qt4, pkgconfig
, withGamepads ? true, SDL # SDL is used for gamepad functionality
}:

let
  version = "0.9.8";
  fstat = x: fn: "-D" + fn + "=" + (if x then "ON" else "OFF");
in stdenv.mkDerivation {
  name = "PPSSPP-${version}";

  src = fetchgit {
    url = "https://github.com/hrydgard/ppsspp.git";
    sha256 = "11sqhb2m3502dzbizahh1w2dl7jv3fipwxyrmryj8fyaqqw0i36q";
    rev = "cbc46be3f91cb8558fbb4b175b14e8e16cbf0243";
    fetchSubmodules = true;
  };

  # Upstream forgot to bump a version in one file.
  patches = [ ./bump-version-to-0.9.8.patch ];

  buildInputs = [ zlib libpng pkgconfig qt4 ]
                ++ (if withGamepads then [ SDL ] else [ ]);

  configurePhase = "cd Qt && qmake PPSSPPQt.pro";
  installPhase = "mkdir -p $out/bin && cp PPSSPPQt $out/bin";

  meta = with stdenv.lib; {
    homepage = "http://www.ppsspp.org/";
    description = "A PSP emulator, the Qt4 version.";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.fuuzetsu ];
  };
}