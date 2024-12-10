{
  lib,
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "ddh";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "darakian";
    repo = pname;
    rev = version;
    sha256 = "XFfTpX4c821pcTAJZFUjdqM940fRoBwkJC6KTknXtCw=";
  };

  cargoSha256 = "6yPDkbag81TZ4k72rbmGT6HWKdGK4yfKxjGNFKEWXPI=";

  meta = with lib; {
    description = "A fast duplicate file finder";
    longDescription = ''
      DDH traverses input directories and their subdirectories.
      It also hashes files as needed and reports findings.
    '';
    homepage = "https://github.com/darakian/ddh";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.all;
    mainProgram = "ddh";
  };
}
