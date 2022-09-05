{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "6.0.0";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-iav1va1EbEj4qWSfe8bzFgdx1U3IeZV60LYk7vD1LoQ=";
  };

  cargoSha256 = "sha256-e4uACIiHelCvLXPCZ4aMa59mX5xuhVFkk0MvS/1uk68=";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
