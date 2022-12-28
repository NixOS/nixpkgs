{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, udev
, libusb1
, segger-jlink
}:

let
  supported = {
    x86_64-linux = {
      name = "linux-amd64";
      sha256 = "0e036afa51c83de7824ef75d34e165ed55efc486697b8ff105639644bce988e5";
    };
    i686-linux = {
      name = "linux-i386";
      sha256 = "ba208559ae1195a0d4342374a0eb79697d31d6b848d180ac906494f17f56623b";
    };
    aarch64-linux = {
      name = "linux-arm64";
      sha256 = "cffa4b8becdb5545705fd138422c648d809b520b7bc6c77b8b50aa1f79ebe845";
    };
    armv7l-linux = {
      name = "linux-armhf";
      sha256 = "c58d330152ae1ef588a5ee1d93777e18b341d4f6a2754642b0ddd41821050a3a";
    };
  };

  platform = supported.${stdenv.system} or (throw "unsupported platform ${stdenv.system}");

  version = "10.16.0";

  url = "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-${lib.versions.major version}-x-x/${lib.versions.major version}-${lib.versions.minor version}-${lib.versions.patch version}/nrf-command-line-tools-${lib.versions.major version}.${lib.versions.minor version}.${lib.versions.patch version}_${platform.name}.tar.gz";

in stdenv.mkDerivation {
  pname = "nrf-command-line-tools";
  inherit version;

  src = fetchurl {
    inherit url;
    inherit (platform) sha256;
  };

  runtimeDependencies = [ segger-jlink ];

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ udev libusb1 ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    rm -rf ./python
    mkdir -p $out
    cp -r * $out

    chmod +x $out/lib/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Nordic Semiconductor nRF Command Line Tools";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Command-Line-Tools";
    license = licenses.unfree;
    platforms = attrNames supported;
    maintainers = with maintainers; [ stargate01 ];
  };
}
