{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "rsign2";
<<<<<<< HEAD
  version = "0.6.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bJeM1HTzmC8QZ488PpqQ0qqdFg1/rjPWuTtqo1GXyHM=";
  };

  cargoHash = "sha256-xqNFJFNV9mIVxzyQvhv5QwHVcXLuH76VYFAsgp5hW+w=";
=======
  version = "0.6.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Ono7cKXccYMmkrlsJ+Z85w8z0fEduuEQhRlHQQk0vzU=";
  };

  cargoHash = "sha256-Yuf4iTWGQp/1ZUVqaR0tKfFxKJ9JEmMLq1LL7gwf6w0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A command-line tool to sign files and verify signatures";
    homepage = "https://github.com/jedisct1/rsign2";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rsign";
  };
}
