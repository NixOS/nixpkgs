{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "elfcat";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "ruslashev";
    repo = pname;
    rev = version;
    sha256 = "sha256-qmyD9BkD00yAQxmkgP2g5uvv/U7D/hUkCMJq44MI4YI=";
  };

  cargoSha256 = null;

  meta = with lib; {
    description = "ELF visualizer, generates HTML files from ELF binaries.";
    homepage = "https://github.com/ruslashev/elfcat";
    license = licenses.zlib;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
