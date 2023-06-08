{ fetchurl }:
rec {
  version = "1.3.2";

  driver = fetchurl {
    url = "https://files.tiltfive.com/tiltfive_driver_${version}_amd64.unpacked_debs.tar.xz";
    sha256 = "sha256-MWxKqFEM6Q3gf8ik6OZk2aSFe6piTGljPOLpstJh0vA=";
  };

  sdk = fetchurl {
    url = "https://files.tiltfive.com/tiltfive_sdk_${version}.tar.xz";
    sha256 = "sha256-LC3DxOOHulgYO266LdHfAS6kiOzcnG7fEON4SJkMQlU=";
  };
}
