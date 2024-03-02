{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "9.0.0";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-1OpSweosYiqtLqCcAw1EsAtBAYVc/VH8kRtVSpmTytM=";
  };

  cargoHash = "sha256-kPdAfqMNOoQPSdv+VLRDUr6AXGPy47UnldXwvpwKp6s=";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
