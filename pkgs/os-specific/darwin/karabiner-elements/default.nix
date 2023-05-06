{ lib, stdenv, fetchurl, cpio, xar, undmg }:

stdenv.mkDerivation rec {
  pname = "karabiner-elements";
  version = "14.11.0";

  src = fetchurl {
    url = "https://github.com/pqrs-org/Karabiner-Elements/releases/download/v${version}/Karabiner-Elements-${version}.dmg";
    sha256 = "sha256-InuSfXbaSYsncq8jVO15LbQmDTguRHlOiE/Pj5EfX5c=";
  };

  outputs = [ "out" "driver" ];

  nativeBuildInputs = [ cpio xar undmg ];

  unpackPhase = ''
    undmg $src
    xar -xf Karabiner-Elements.pkg
    cd Installer.pkg
    zcat Payload | cpio -i
    cd ../Karabiner-DriverKit-VirtualHIDDevice.pkg
    zcat Payload | cpio -i
    cd ..
  '';

  sourceRoot = ".";

  postPatch = ''
    for f in *.pkg/Library/Launch{Agents,Daemons}/*.plist; do
      substituteInPlace $f \
        --replace "/Library/" "$out/Library/"
    done
  '';

  installPhase = ''
    mkdir -p $out $driver
    cp -R Installer.pkg/Applications Installer.pkg/Library $out
    cp -R Karabiner-DriverKit-VirtualHIDDevice.pkg/Applications Karabiner-DriverKit-VirtualHIDDevice.pkg/Library $driver

    cp "$out/Library/Application Support/org.pqrs/Karabiner-Elements/package-version" "$out/Library/Application Support/org.pqrs/Karabiner-Elements/version"
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    description = "Karabiner-Elements is a powerful utility for keyboard customization on macOS Sierra (10.12) or later.";
    homepage = "https://karabiner-elements.pqrs.org/";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ Enzime ];
    license = licenses.unlicense;
  };
}
