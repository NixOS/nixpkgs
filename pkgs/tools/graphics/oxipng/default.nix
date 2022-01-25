{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "5.0.1";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    sha256 = "1g2m6ifmppgq086w3vzdsihnba4qrzmnf5k13bgah2qasnl97qfh";
  };

  cargoSha256 = "1dkfplmi21wgks8pfxxc3kww89i9wq7fq5j7jm7a8zi59p3xdars";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
