{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l68pcln18hgvqayhdnjv70fcs2y7j3fpiyfm3kl0gpykj7l969r";
  };

  cargoSha256 = "0j953c2h5asvr6fvklbdkk7vkdzdbp9zbzxxiic1gjv953gmw0qq";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
