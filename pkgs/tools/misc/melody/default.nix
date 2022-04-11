{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "melody";
  version = "0.13.9";

  src = fetchCrate {
    pname = "melody_cli";
    inherit version;
    sha256 = "1vqiciridm0pbh5yf42p2jfis908p6r9q3jaqy2hx3f5aggbf09q";
  };

  cargoSha256 = "1gf2km06qzvc0xv4vfxm6vdp3c5lgcjwwl92f4frga3cx51vbrzh";

  meta = with lib; {
    description = "Language that compiles to regular expressions";
    homepage = "https://github.com/yoav-lavi/melody";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
