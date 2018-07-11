{ stdenv, fetchFromGitHub
# nativeBuildInputs
, qmake, pkgconfig, makeWrapper
# Qt
, qtbase, qtsvg, qtwebengine
# buildInputs
, radare2
, python3 }:


stdenv.mkDerivation rec {
  name = "radare2-cutter-${version}";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "v${version}";
    sha256 = "0xwls8jhhigdkwyq3nf9xwcz4inm5smwinkyliwmfzvfflbbci5c";
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

  nativeBuildInputs = [ qmake pkgconfig makeWrapper ];
  buildInputs = [ qtbase qtsvg qtwebengine radare2 python3 ];

  qmakeFlags = [
    "CONFIG+=link_pkgconfig"
    "PKGCONFIG+=r_core"
    # Leaving this enabled doesn't break build but generates errors
    # at runtime (to console) about being unable to load needed bits.
    # Disable until can be looked at.
    "CUTTER_ENABLE_JUPYTER=false"
  ];

  # Fix crash on startup in some situations
  postInstall = ''
    wrapProgram $out/bin/Cutter \
      --prefix QT_PLUGIN_PATH : ${qtbase.bin}/${qtbase.qtPluginPrefix} \
      --prefix LD_LIBRARY_PATH : ${qtbase.out}/lib
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A Qt and C++ GUI for radare2 reverse engineering framework";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
