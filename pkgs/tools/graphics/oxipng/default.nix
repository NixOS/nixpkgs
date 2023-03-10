{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "8.0.0";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-stTwsU9XK3lF4q2sDgb9A1KG1NnhCfVxYWRiBvlmiqQ=";
  };

  cargoHash = "sha256-XMIsdv2AHMGs0tDEWe3cfplZU9CbqEkHd7L5eS+V7j0=";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
