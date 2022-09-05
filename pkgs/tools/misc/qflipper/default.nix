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
, nix-update-script
}:
let
  pname = "qFlipper";
  version = "1.1.3";
  sha256 = "sha256-/MYX/WnK3cClIOImb5/awT8lX2Wx8g+r/RVt3RH7d0c=";
  timestamp = "99999999999";
  commit = "nix-${version}";

  udev_rules = ''
    #Flipper Zero serial port
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
    #Flipper Zero DFU
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess"
  '';

in
mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "flipperdevices";
    repo = "qFlipper";
    rev = version;
    fetchSubmodules = true;
    inherit sha256;
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
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
    tee $out/etc/udev/rules.d/42-flipperzero.rules << EOF
    ${udev_rules}
    EOF
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Cross-platform desktop tool to manage your flipper device";
    homepage = "https://flipperzero.one/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cab404 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ]; # qtbase doesn't build yet on aarch64-darwin
  };

}
