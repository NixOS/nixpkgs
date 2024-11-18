{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "agg";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "agg";
    rev = "v${version}";
    sha256 = "sha256-WCUYnveTWWQOzhIViMkSnyQ6vgLs5HDLWa/xvfZMh3A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-q4T4Tbl1NPzA7/X21KglhoWTRrYnVQ5ULrSa6UZm8lc=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder";
    homepage = "https://github.com/asciinema/agg";
    changelog = "https://github.com/asciinema/agg/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "agg";
  };
}
