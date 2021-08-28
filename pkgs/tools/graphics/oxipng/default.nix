{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "4.0.3";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-lvVgoAZMIqmbS6yMul9Hf9PtneEVy+jDs3kU1jSBL2w=";
  };

  cargoSha256 = "sha256-sxvOFxSZCANBa/448SpjoLqk/HjqtaFrOhjrQro446Q=";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
