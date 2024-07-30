{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, zlib
, libusb1
, libGL
, qmake
, wrapGAppsHook3
, wrapQtAppsHook
, mkDerivation

, qttools
, qtbase
, qt3d
, qtsvg
, qtserialport
, qtdeclarative
, qtquickcontrols
, qtquickcontrols2
, qtgraphicaleffects
, qtwayland
, nix-update-script
}:
let
  pname = "qFlipper";
  version = "1.3.3";
  hash = "sha256-/Xzy+OA0Nl/UlSkOOZW2YsOHdJvS/7X3Z3ITkPByAOc=";
  timestamp = "99999999999";
  commit = "nix-${version}";

in
mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "flipperdevices";
    repo = "qFlipper";
    rev = version;
    fetchSubmodules = true;
    inherit hash;
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
    wrapGAppsHook3
    wrapQtAppsHook
  ];

  buildInputs = [
    zlib
    libusb1
    libGL

    qtbase
    qt3d
    qtsvg
    qtserialport
    qtdeclarative
    qtquickcontrols
    qtquickcontrols2
    qtgraphicaleffects
  ] ++ lib.optionals (stdenv.isLinux) [
    qtwayland
  ];

  qmakeFlags = [
    "DEFINES+=DISABLE_APPLICATION_UPDATES"
    "CONFIG+=qtquickcompiler"
  ];

  dontWrapGApps = true;

  postPatch = ''
    substituteInPlace qflipper_common.pri \
        --replace 'GIT_VERSION = unknown' 'GIT_VERSION = "${version}"' \
        --replace 'GIT_TIMESTAMP = 0' 'GIT_TIMESTAMP = ${timestamp}' \
        --replace 'GIT_COMMIT = unknown' 'GIT_COMMIT = "${commit}"'
    cat qflipper_common.pri
  '';

  postInstall = ''
    mkdir -p $out/bin
    ${lib.optionalString stdenv.isDarwin ''
    cp qFlipper.app/Contents/MacOS/qFlipper $out/bin
    ''}
    cp qFlipper-cli $out/bin

    mkdir -p $out/etc/udev/rules.d
    cp installer-assets/udev/42-flipperzero.rules $out/etc/udev/rules.d/
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Cross-platform desktop tool to manage your flipper device";
    homepage = "https://flipperzero.one/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cab404 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ]; # qtbase doesn't build yet on aarch64-darwin
  };
}
