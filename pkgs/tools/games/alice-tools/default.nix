{ stdenv
, lib
, gitUpdater
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, bison
, flex
, libiconv
, libpng
, libjpeg
, libwebp
, zlib
, withGUI ? true
, qtbase ? null
, wrapQtAppsHook ? null
}:

assert withGUI -> qtbase != null && wrapQtAppsHook != null;

stdenv.mkDerivation rec {
  pname = "alice-tools";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "nunuhara";
    repo = "alice-tools";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-uXiNNneAOTDupgc+ZvaeRNbEQFJBv4ppdEc3kZeUsg8=";
  };

  patches = [
    # These two patches (one to alice-tools, one to a subproject) improve DCF & PCF parsing
    # Remove them when version > 0.12.1
    (fetchpatch {
      url = "https://github.com/nunuhara/alice-tools/commit/c800e85b37998d7a47060f5da4b1782d7201a042.patch";
      excludes = [ "subprojects/libsys4" ];
      hash = "sha256-R5ckFHqUWHdAPkFa53UbVeLgxJg/8qGLTQWwj5YRJc4=";
    })
    (fetchpatch {
      url = "https://github.com/nunuhara/libsys4/commit/cff2b826d1618fb17616cdd288ab0c50f35e8032.patch";
      stripLen = 1;
      extraPrefix = "subprojects/libsys4/";
      hash = "sha256-CmetiVP2kGL+MwuE9OoEDrDFxzwWvv1TtZuq1li1uIw=";
    })
  ];

  postPatch = lib.optionalString (withGUI && lib.versionAtLeast qtbase.version "6.0") ''
    substituteInPlace src/meson.build \
      --replace qt5 qt6
  '';

  mesonFlags = lib.optionals (withGUI && lib.versionAtLeast qtbase.version "6.0") [
    # Qt6 requires at least C++17, project uses compiler's default, default too old on Darwin & aarch64-linux
    "-Dcpp_std=c++17"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    bison
    flex
  ] ++ lib.optionals withGUI [
    wrapQtAppsHook
  ];

  buildInputs = [
    libiconv
    libpng
    libjpeg
    libwebp
    zlib
  ] ++ lib.optionals withGUI [
    qtbase
  ];

  dontWrapQtApps = true;

  # Default install step only installs a static library of a build dependency
  installPhase = ''
    runHook preInstall

    install -Dm755 src/alice $out/bin/alice
  '' + lib.optionalString withGUI ''
    install -Dm755 src/galice $out/bin/galice
    wrapQtApp $out/bin/galice
  '' + ''

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Tools for extracting/editing files from AliceSoft games";
    homepage = "https://github.com/nunuhara/alice-tools";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
    mainProgram = if withGUI then "galice" else "alice";
  };
}
