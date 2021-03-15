{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-68fOJlDuuVFqGHXojN/y0h8kcPwrg7F480UOr5zrjFg=";
  };

  cargoSha256 = "sha256-KZEtkD/6ygyvkeebdX70vB8n+B7JODWT2h63dUd5CoQ=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
