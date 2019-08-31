{ stdenv, fetchFromGitHub
# nativeBuildInputs
, qmake, pkgconfig
# Qt
, qtbase, qtsvg, qtwebengine
# buildInputs
, r2-for-cutter
, python3 }:

stdenv.mkDerivation rec {
  pname = "radare2-cutter";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "v${version}";
    sha256 = "03f3cdckh51anx9gd1b0ndb2fg7061hqngvygf32ky29mm2m2lyv";
  };

  postUnpack = "export sourceRoot=$sourceRoot/src";

  # Remove this "very helpful" helper file intended for discovering r2,
  # as it's a doozy of harddcoded paths and unexpected behavior.
  # Happily Nix has everything all set so we don't need it,
  # other than as basis for the qmakeFlags set below.
  postPatch = ''
    substituteInPlace Cutter.pro \
      --replace "include(lib_radare2.pri)" ""
  '';

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ qtbase qtsvg qtwebengine r2-for-cutter python3 ];

  qmakeFlags = [
    "CONFIG+=link_pkgconfig"
    "PKGCONFIG+=r_core"
    # Leaving this enabled doesn't break build but generates errors
    # at runtime (to console) about being unable to load needed bits.
    # Disable until can be looked at.
    "CUTTER_ENABLE_JUPYTER=false"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A Qt and C++ GUI for radare2 reverse engineering framework";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
