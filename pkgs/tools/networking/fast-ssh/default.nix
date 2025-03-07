{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "fast-ssh";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "julien-r44";
    repo = "fast-ssh";
    tag = "v${version}";
    hash = "sha256-Wn1kwuY1tRJVe9DJexyQ/h+Z1gNtluj78QpBYjeCbSE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qkvonLuS18BBPdBUUnIAbmA+9ZJZFmTRaewrnK9PHFE=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  meta = with lib; {
    description = "TUI tool to use the SSH config for connections";
    homepage = "https://github.com/julien-r44/fast-ssh";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "fast-ssh";
  };
}
