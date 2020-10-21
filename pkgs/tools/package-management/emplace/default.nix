{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ihx6hrzs7wkdz9wzgarmm73dz1fb2bhssmxrgv5nzmkhygn4xfy";
  };

  cargoSha256 = "0yqg2hagsjaxvrj96qg6k1llkmqdqp792c2844h7fhnhlx6v2wd2";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
