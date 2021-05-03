{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    sha256 = "0a4yikkqppawii1q0kzsxwfp1aid688wa0lixjwfsl279lr69css";
  };

  cargoSha256 = "08k60gd23yanfraxpbw9hi7jbqgsxz9mv1ci6q9piis5742zlj9s";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
