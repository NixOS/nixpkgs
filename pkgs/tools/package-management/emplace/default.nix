{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6dmXWqkf8Z+cc4wnOuVCe4+Byfk3VTYXehTN1MCiFLE=";
  };

  cargoSha256 = "sha256-uDoxMHSNoqH/AOixmkV6pwrDu/XSqXBCrAz4L7MMPU8=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
