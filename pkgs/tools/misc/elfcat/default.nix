{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "elfcat";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "ruslashev";
    repo = pname;
    rev = version;
    sha256 = "sha256-gh5JO3vO2FpHiZfaHOODPhRSB9HqZe1ir4g7UEkSUHY=";
  };

  cargoSha256 = null;

  meta = with lib; {
    description = "ELF visualizer, generates HTML files from ELF binaries.";
    homepage = "https://github.com/ruslashev/elfcat";
    license = licenses.zlib;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
