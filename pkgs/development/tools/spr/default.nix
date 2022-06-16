{ lib
, rustPlatform
, fetchCrate
, Security
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "spr";
  version = "1.3.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-6IPNA1Ivj3o+X733a8Kxh1STODS5lLZaK4lh0lxU4bo=";
  };

  cargoSha256 = "sha256-m/mHOiuaFJtiuyFr2Z3ovk/Q06vxwvUBAiz0rF4R3kU=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Submit pull requests for individual, amendable, rebaseable commits to GitHub";
    homepage = "https://github.com/getcord/spr";
    license = licenses.mit;
    maintainers = with maintainers; [ sven-of-cord ];
  };
}
