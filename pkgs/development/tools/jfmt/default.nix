{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "jfmt";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "scruffystuffs";
    repo = "${pname}.rs";
    rev = "v${version}";
    hash = "sha256-X3wk669G07BTPAT5xGbAfIu2Qk90aaJIi1CLmOnSG80=";
  };

  cargoHash = "sha256-u/v3P7iPdBJU/0wlSNBq/cjnM3XOnoVfUjrrmo4sTAA=";

  meta = with lib; {
    description = "CLI utility to format json files";
    homepage = "https://github.com/scruffystuffs/jfmt.rs";
    changelog = "https://github.com/scruffystuffs/jfmt.rs/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.psibi ];
  };
}
