{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tere";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mgunyho";
    repo = "tere";
    rev = "v${version}";
    sha256 = "sha256-jousyoro1Mn1+yBzUkGxW7/zbNvF7+Y4/WLRj99Iuy0=";
  };

  cargoSha256 = "sha256-hMAxKijmlckkCtQZiC5ubaZQKU2m99gL/MkYoU7zQxU=";

  postPatch = ''
    rm .cargo/config.toml;
  '';

  meta = with lib; {
    description = "A faster alternative to cd + ls";
    homepage = "https://github.com/mgunyho/tere";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
