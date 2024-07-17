{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "pazi";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "euank";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z8x70mwg0mvz6iap92gil37d4kpg5dizlyfx3zk7984ynycgap8";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "1iamlp5519h8mmgd4964cvyp7mmnqdg2d3qj5v7yzilyp4nz15jc";

  meta = with lib; {
    description = "An autojump \"zap to directory\" helper";
    homepage = "https://github.com/euank/pazi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    mainProgram = "pazi";
  };
}
