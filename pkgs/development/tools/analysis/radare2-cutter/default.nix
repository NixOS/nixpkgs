{ stdenv, fetchFromGitHub
# nativeBuildInputs
, qmake, pkgconfig
# Qt
, qtbase, qtsvg, qtwebengine
# buildInputs
, radare2
, python3 }:

let
  r2 = radare2.overrideDerivation (o: {
    name = "radare2-for-cutter-${version}";
    src = fetchFromGitHub {
      owner = "radare";
      repo = "radare2";
      # XXX: The revision used here should match what Cutter uses as submodule.
      # For now it's the revision cutter-git uses for r2.
      rev = "c9ec8b54b9ba32ba6712f319825f8d032e573e68";
      sha256 = "04ri3wis8l1mbcp2gx419x7yfimljn7xa01izch71jy2h2mzk3z6";
    };
  });
  version = "1.6";
in
stdenv.mkDerivation rec {
  name = "radare2-cutter-${version}";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "v${version}";
    sha256 = "1ps52yf94yfnws3nn1iiwch2jy33dyvi7j47xkmh0m5fpdqi5xk7";
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
  buildInputs = [ qtbase qtsvg qtwebengine r2 python3 ];

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
    maintainers = with maintainers; [ dtzWill ];
  };
}
