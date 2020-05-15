{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wg8wavbs063dnpjia7wd60nf97v7pl4lm6s9xndpai1r1c99c2d";
  };

  cargoSha256 = "0igq8aml22c26w43zgk2gii8yl8mhs8ikfh0bn32ajwigqfk4vaq";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
