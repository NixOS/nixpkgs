{ lib, rustPlatform, fetchFromGitHub, pkg-config, udev, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "ldproxy";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "embuild";
    rev = "${pname}-v${version}";
    sha256 = "sha256-CPMcFzfP/l1g04sBLWj2pY76F94mNsr1RGom1sfY23I=";
  };

  buildAndTestSubdir = "ldproxy";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  cargoSha256 = "sha256-u4G5LV/G6Iu3FUeY2xdeXgVdiXLpGIC2UUYbUr0w3n0=";

  meta = with lib; {
    description = "Build support for embedded Rust: Cargo integration with other embedded build ecosystems & tools, like PlatformIO, CMake and kconfig";
    homepage = "https://github.com/esp-rs/embuild";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

