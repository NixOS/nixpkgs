{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jhv7c68ymwaq9fr586rjbgcaxpkxcr0d3pq7lyhbzihaywz7m6m";
  };

  cargoSha256 = "1n4k8mnsix3sy6pmqkk7wymknn1mn5dkwa9i90nlb4k2h9y709wj";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
