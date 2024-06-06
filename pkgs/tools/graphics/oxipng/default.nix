{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "9.1.1";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-I+1yQQEzhGApvHxPM8W1wySQtDglGp3V4vkwoTd92EU=";
  };

  cargoHash = "sha256-miXrQVFahz9WYRCduSF5+RSY4j/XNEt8lnSuOohBUFU=";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
