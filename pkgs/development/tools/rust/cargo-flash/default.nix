{ lib, stdenv, rustPlatform, fetchFromGitHub, libusb1, pkg-config, rustfmt
, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flash";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s49q8x0iscy9rgn9zgymyg39cqm251a99m341znjn55lap3pdl8";
  };

  cargoSha256 = "0rb4s5bwjs7hri636r2viva96a6z9qjv9if6i220j9yglrvi7c8i";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    changelog =
      "https://github.com/probe-rs/cargo-flash/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ fooker ];
  };
}
