{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zw7lbm6ly2c607ha9gbriknzqbgh3hkqb83507hah1hanzp7zq9";
  };

  cargoSha256 = "166nsk3v3w5ji7k8hflvjylz8hkgbxqrdwb03m7l8ak8wgkycxzx";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
