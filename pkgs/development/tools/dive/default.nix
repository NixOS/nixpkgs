{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dive";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pyrdff5qqc0l3h4nssa9a7qnfqwy2p6ywc8nbwyc7wvzgdiczb8";
  };

  modSha256 = "1fk9z7a6wghrs15pc28g5ri7rkbb1ifjb91rscwqsmh10r2wik4w";

  meta = with lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = https://github.com/wagoodman/dive;
    license = licenses.mit;
    maintainers = with maintainers; [ marsam spacekookie ];
  };
}
