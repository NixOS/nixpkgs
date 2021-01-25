{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname   = "rargs";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner  = "lotabout";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "188gj05rbivci1z4z29vwdwxlj2w01v5i4avwrxjnj1dd6mmlbxd";
  };

  cargoSha256 = "0qzkhx0n28f5wy4fral3adn499q3f10q71cd544s4ghqwqn4khc9";

  doCheck=false;  # `rargs`'s test depends on the deprecated `assert_cli` crate, which in turn is not in Nixpkgs

  meta = with lib; {
    description = "xargs + awk with pattern matching support";
    homepage    = "https://github.com/lolabout/rargs";
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ pblkt ];
  };
}
