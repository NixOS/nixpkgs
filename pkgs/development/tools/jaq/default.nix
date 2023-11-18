{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
    hash = "sha256-Wz10goMJYWbFak4v10W6ez+z+T+ohG06HU+rS8AXQqg=";
  };

  cargoHash = "sha256-fvuwn5pA33QE4YplG5VAkHF1MgwRni0nbA6B2JkNndU=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda siraben ];
    mainProgram = "jaq";
  };
}
