{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "aoc-cli";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "scarvalhojr";
    repo = pname;
    rev = version;
    hash = "sha256-UdeCKhEWr1BjQ6OMLP19OLWPlvvP7FGAO+mi+bQUPQA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-EluP4N3UBQeEKVdHTs4O0THXji+nAyE52nGKsxA3AA4=";

  meta = with lib; {
    description = "Advent of code command line tool";
    homepage = "https://github.com/scarvalhojr/aoc-cli/";
    license = licenses.mit;
    maintainers = with maintainers; [ jordanisaacs ];
    mainProgram = "aoc";
  };
}
