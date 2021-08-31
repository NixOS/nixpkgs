{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "elfcat";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ruslashev";
    repo = pname;
    rev = version;
    sha256 = "sha256-v8G9XiZS+49HtuLjs4Co9A1J+5STAerphkLaMGvqXT4=";
  };

  cargoSha256 = null;

  meta = with lib; {
    description = "ELF visualizer, generates HTML files from ELF binaries.";
    homepage = "https://github.com/ruslashev/elfcat";
    license = licenses.zlib;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
