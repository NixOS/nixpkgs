{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "elfcat";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "ruslashev";
    repo = pname;
    rev = version;
    sha256 = "sha256-NzFKNCCPWBj/fhaEJF34nyeyvLMeQwIcQgTlYc6mgYo=";
  };

  # There is no dependency to vendor in this project.
  cargoLock.lockFile = ./Cargo.lock;

  meta = with lib; {
    description = "ELF visualizer, generates HTML files from ELF binaries.";
    homepage = "https://github.com/ruslashev/elfcat";
    license = licenses.zlib;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
