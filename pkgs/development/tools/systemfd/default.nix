{ lib
, fetchFromGitHub
, rustPlatform
}:

let
  version = "0.4.2";

in
rustPlatform.buildRustPackage {

  pname = "systemfd";
  inherit version;

  src = fetchFromGitHub {
    repo = "systemfd";
    owner = "mitsuhiko";
    rev = version;
    sha256 = "sha256-MASpQJkqmKpHZzMxHqAsuVO50dHHTv74Rnbv1gLapTU=";
  };

  cargoHash = "sha256-zgRbaZchdqzr+E6gqltSte9dGMnjbrM7/7t0BiNn4kA=";

  meta = {
    description = "Convenient helper for passing sockets into another process";
    mainProgram = "systemfd";
    homepage = "https://github.com/mitsuhiko/systemfd";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.adisbladis ];
    platforms = lib.platforms.unix;
  };

}
