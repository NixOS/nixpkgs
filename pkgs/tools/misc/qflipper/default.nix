{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, zlib
, libusb1
, libGL
, qmake
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
}:
let
  version = "0.8.2";
  timestamp = "99999999999";
  commit = "nix-${version}";
  hash = "sha256-BaqKlF2SZueykFhtj91McP39oXYAx+lz8eXhn5eouqg=";

  udev_rules = ''
    #Flipper Zero serial port
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
    #Flipper Zero DFU
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess"
  '';

in
mkDerivation {
  pname = "qFlipper";
  inherit version;

  src = fetchFromGitHub {
    owner = "flipperdevices";
    repo = "qFlipper";
    rev = version;
    inherit hash;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
  ];

  buildInputs = [
    zlib
    libusb1
    libGL
    wrapQtAppsHook

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

  preBuild = ''
    substituteInPlace qflipper_common.pri \
        --replace 'GIT_VERSION = unknown' 'GIT_VERSION = "${version}"' \
        --replace 'GIT_TIMESTAMP = 0' 'GIT_TIMESTAMP = ${timestamp}' \
        --replace 'GIT_COMMIT = unknown' 'GIT_COMMIT = "${commit}"'
    cat qflipper_common.pri

  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ${lib.optionalString stdenv.isLinux ''
      install -Dm755 qFlipper $out/bin/qFlipper
    ''}
    ${lib.optionalString stdenv.isDarwin ''
      install -Dm755 qFlipper.app/Contents/MacOS/qFlipper $out/bin/qFlipper
    ''}
    cp qFlipperTool $out/bin

    mkdir -p $out/share/applications
    cp installer-assets/appimage/qFlipper.desktop $out/share/applications

    mkdir -p $out/share/icons
    cp application/assets/icons/qFlipper.png $out/share/icons

    mkdir -p $out/etc/udev/rules.d
    tee $out/etc/udev/rules.d/42-flipperzero.rules << EOF
    ${udev_rules}
    EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform desktop tool to manage your flipper device";
    homepage = "https://flipperzero.one/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cab404 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ]; # qtbase doesn't build yet on aarch64-darwin
  };

}
