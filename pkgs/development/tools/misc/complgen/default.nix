{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "complgen";
  version = "unstable-2023-07-05";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "e23474c3bd4544a8e6f7b51947616dbdb18fe1dd";
    hash = "sha256-Ura4/yMLVRlgTiNiXNPMtKu4cPWge0bLQp/n+tgeDiM=";
  };

  cargoHash = "sha256-P7wHKrRUVlrLAaLYhVH/p3oOc7UCGP3aQZotVxyeJTs=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
