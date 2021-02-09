{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OKKAYZz2ytiuc/U4fOZepBDvupzQdWC0Wk3wDi+Ih6w=";
  };

  cargoSha256 = "sha256-jEplQ/r/XPvLIQrQAiR1Fde5yfE98UuqDazPcEgvo+w=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
