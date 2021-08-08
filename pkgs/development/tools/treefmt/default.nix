{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    sha256 = "1j505bjdgd6lsq197frlyw26fl1621aw6z339bdp7zc3sa54z0d6";
  };

  cargoSha256 = "0aky94rq1gs506yhpinj759lpvlnw3q2k97gvq34svgq0n38drvk";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
