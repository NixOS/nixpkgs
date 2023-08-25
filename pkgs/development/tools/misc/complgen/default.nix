{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "complgen";
  version = "unstable-2023-08-17";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "4f01c04184b31804009e0002ff6ba1c777439798";
    hash = "sha256-KQFMWVHTlkf65ghgv3oR2Jz4QtXkdz6CNIC3eeyBgBg=";
  };

  cargoHash = "sha256-m/eFpwMZOOVGVeXjQwNZheuPeGkJd0mAF903ML/Kr90=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
