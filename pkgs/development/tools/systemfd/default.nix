{ lib
, fetchFromGitHub
, rustPlatform
}:

let
  version = "0.4.4";

in
rustPlatform.buildRustPackage {

  pname = "systemfd";
  inherit version;

  src = fetchFromGitHub {
    repo = "systemfd";
    owner = "mitsuhiko";
    rev = version;
    sha256 = "sha256-U+pBKuoMhyIOhLl1nzmxk5yFt9nOq/KZ6rx9JhalLmM=";
  };

  cargoHash = "sha256-k8FgdNVjFYO/lflVzRQUwHvdy4+eCNTnTYImdfy1GaQ=";

  meta = {
    description = "Convenient helper for passing sockets into another process";
    mainProgram = "systemfd";
    homepage = "https://github.com/mitsuhiko/systemfd";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.adisbladis ];
    platforms = lib.platforms.unix;
  };

}
