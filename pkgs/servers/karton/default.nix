{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "karton";
  version = "2.0.0";

  # GitHub sources do not have Cargo.lock
  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-dBMRgIu1uMe+YNuKO21hziKKoWSF2ha/2pDedrX67W8=";
  };

  cargoSha256 = "sha256-MzRpLGHDtF1PumS0L1H26EH257PZnTPNw/8Fip3FTn4=";

  meta = with lib; {
    description = "A lightweight pastebin application written in rust and a fork from microbin";
    homepage = "https://gitlab.com/obsidianical/microbin";
    license = licenses.bsd3;
    maintainers = with maintainers; [ schrottkatze ];
  };
}
