{ lib
, fetchFromGitHub
, rustPlatform
}:

let
  version = "0.4.3";

in
rustPlatform.buildRustPackage {

  pname = "systemfd";
  inherit version;

  src = fetchFromGitHub {
    repo = "systemfd";
    owner = "mitsuhiko";
    rev = version;
    sha256 = "sha256-Ypt9/dqDrurhiEhahVk8gG3QxP2ZKTeL7F0IVUGE8Kw=";
  };

  cargoHash = "sha256-1t+yYqPDMEI39kieGkm+EUVzDBsTlDWQ7iGyjepjc7s=";

  meta = {
    description = "Convenient helper for passing sockets into another process";
    mainProgram = "systemfd";
    homepage = "https://github.com/mitsuhiko/systemfd";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.adisbladis ];
    platforms = lib.platforms.unix;
  };

}
