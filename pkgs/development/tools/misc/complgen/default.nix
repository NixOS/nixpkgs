{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "complgen";
  version = "unstable-2023-08-07";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "7c81398e66e5728e0247b61e2210aad0b7a1d002";
    hash = "sha256-ToyvyXuesBKxi8qLo1YLUvIlhjEmkoiOu8+inPCgyU8=";
  };

  cargoHash = "sha256-fH+yeuup2USkW8L2/CEmSx++u0wHrCsMuugCmJ+L6jw=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
