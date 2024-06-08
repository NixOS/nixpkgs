{ lib
, fetchFromGitHub
, rustPlatform
}:

let
  version = "0.4.0";

in
rustPlatform.buildRustPackage {

  pname = "systemfd";
  inherit version;

  src = fetchFromGitHub {
    repo = "systemfd";
    owner = "mitsuhiko";
    rev = version;
    sha256 = "sha256-HUJgYPD4C9fMUYKpzmIy9gDT6HAZDWw1JLMKLgzRQTY=";
  };

  cargoSha256 = "sha256-UhfE9Q5E79rN2mjkNB5IAN/J0fbpoy9CmM6ojHQcFP0=";

  meta = {
    description = "A convenient helper for passing sockets into another process";
    mainProgram = "systemfd";
    homepage = "https://github.com/mitsuhiko/systemfd";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.adisbladis ];
    platforms = lib.platforms.unix;
  };

}
