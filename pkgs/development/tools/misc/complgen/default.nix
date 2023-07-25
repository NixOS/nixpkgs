{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "complgen";
  version = "unstable-2023-07-10";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "6b1fbc50d56061c74e3324362b23ba5211aaff25";
    hash = "sha256-y94DOMW3w+/YJ4uNvEM4y/dZXZuwFPYhDuh2TOyBn8U=";
  };

  cargoHash = "sha256-fzLM1vxY1FBpw/5JDp4+VO9SVfCQCH8Et5a0WTYSHwk=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
