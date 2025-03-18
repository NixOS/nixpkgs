{ lib
, rustPlatform
, fetchCrate
, Security
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "spr";
  version = "1.3.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lsdWInJWcofwU3P4vAWcLQeZuV3Xn1z30B7mhODJ4Vc=";
  };

  cargoHash = "sha256-VQg3HDNw+L1FsFtHXnIw6dMVUxV63ZWHCxiknzsqXW8=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Submit pull requests for individual, amendable, rebaseable commits to GitHub";
    mainProgram = "spr";
    homepage = "https://github.com/getcord/spr";
    license = licenses.mit;
    maintainers = with maintainers; [ sven-of-cord ];
  };
}
