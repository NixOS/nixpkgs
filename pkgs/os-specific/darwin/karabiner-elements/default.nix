{ lib, stdenvNoCC, fetchurl, darwin }:

darwin.installBinaryPackage rec {
  pname = "karabiner-elements";
  version = "14.13.0";

  src = fetchurl {
    url = "https://github.com/pqrs-org/Karabiner-Elements/releases/download/v${version}/Karabiner-Elements-${version}.dmg";
    hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
  };

  outputs = [ "out" "driver" ];

  postUnpack = ''
    pushd ''${sourceRoot}
    unpackPkg Karabiner-Elements-${version}/Karabiner-Elements.pkg .
    bsdtar -xf Installer.pkg/Payload -C Installer.pkg
    bsdtar -xf Karabiner-DriverKit-VirtualHIDDevice.pkg/Payload -C Karabiner-DriverKit-VirtualHIDDevice.pkg
    popd
  '';

  dontPatch = false;
  postPatch = ''
    for f in *.pkg/Library/Launch{Agents,Daemons}/*.plist; do
      substituteInPlace $f \
        --replace-fail "/Library/" "$out/Library/"
    done
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out $driver
    cp -R Installer.pkg/Applications Installer.pkg/Library $out
    cp -R Karabiner-DriverKit-VirtualHIDDevice.pkg/Applications Karabiner-DriverKit-VirtualHIDDevice.pkg/Library $driver
    cp "$out/Library/Application Support/org.pqrs/Karabiner-Elements/package-version" "$out/Library/Application Support/org.pqrs/Karabiner-Elements/version"
    runHook postInstall
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    description = "Karabiner-Elements is a powerful utility for keyboard customization on macOS Sierra (10.12) or later.";
    homepage = "https://karabiner-elements.pqrs.org/";
    maintainers = with maintainers; [ Enzime ];
    license = licenses.unlicense;
  };
}
