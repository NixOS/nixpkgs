{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "diskonaut";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = "diskonaut";
    rev = version;
    sha256 = "1pmbag3r2ka30zmy2rs9jps2qxj2zh0gy4a774v9yhf0b6qjid54";
  };

  cargoSha256 = "10jrcy8m9ll4136ghq3fhmnphd9g3rw863x708vm17n44kgdxyab";

  # 1 passed; 44 failed https://hydra.nixos.org/build/148943783/nixlog/1
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Terminal disk space navigator";
    homepage = "https://github.com/imsnif/diskonaut";
    license = licenses.mit;
    maintainers = with maintainers; [ evanjs figsoda ];
    mainProgram = "diskonaut";
  };
}
