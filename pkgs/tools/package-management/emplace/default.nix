{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5t47QrYWbm8A4E1GhqZwME7rmSfU1SYVniRGSrcRpvk=";
  };

  cargoSha256 = "sha256-/GFpjovPGEgkfJ53+wR8CBDXiQQPDCiIaRG2Ka71dhQ=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
