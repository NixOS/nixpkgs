{ lib, fetchFromGitHub, rustPlatform, pkg-config, libusb1 }:

rustPlatform.buildRustPackage rec {
  pname = "ecpdap";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "adamgreig";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z8w37i6wjz6cr453md54ip21y26605vrx4vpq5wwd11mfvc1jsg";
  };

  # The lock file was not up to date with cargo.toml for this release
  #
  # This patch is the lock file after running `cargo update`
  cargoPatches = [ ./lock-update.patch ];

  cargoSha256 = "08xcnvbxm508v03b3hmz71mpa3yd8lamvazxivp6qsv46ri163mn";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "A tool to program ECP5 FPGAs";
    longDescription = ''
      ECPDAP allows you to program ECP5 FPGAs and attached SPI flash
      using CMSIS-DAP probes in JTAG mode.
    '';
    homepage = "https://github.com/adamgreig/ecpdap";
    license = licenses.asl20;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}

