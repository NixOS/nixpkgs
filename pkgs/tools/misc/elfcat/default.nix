{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "elfcat";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ruslashev";
    repo = pname;
    rev = version;
    sha256 = "sha256-s56FyRoD2IhgdwEV63jMaB265CodHUlvmrWzmXAmonY=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  meta = with lib; {
    description = "ELF visualizer, generates HTML files from ELF binaries.";
    homepage = "https://github.com/ruslashev/elfcat";
    license = licenses.zlib;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
