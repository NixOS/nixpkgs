{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "complgen";
  version = "unstable-2023-08-22";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "8c9b9c51f3465c6d858e15f442b63e94b2f5ed1b";
    hash = "sha256-oYRaH3FbAFY7QujgFpUDD8gVam4+Gm9qROxCTMYBg9I=";
  };

  cargoHash = "sha256-LHnIIkQLuY+A09qhxSiyLmUpX/dES7xBE5m1uRPI0i0=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
