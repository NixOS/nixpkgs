{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "5.0.0";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-rTAY+3ViPkOsRjT9FHKnVOEGfLscuBdMAiQq+N9PRNU=";
  };

  cargoSha256 = "sha256-Z5tA2bUE/5qGKXP2hIKo6tBegaSUALRzEZ/Xext3EWY=";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
