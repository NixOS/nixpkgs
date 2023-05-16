{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, IOKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "oxigraph";
<<<<<<< HEAD
  version = "0.3.19";
=======
  version = "0.3.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-lVPRg9zU3VOTrxr2pTHzfvaGjoP/h88W4JmQhOKshRc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-+wh6qHXW9KXXOkMIkRr+tI3ViBrHpE2G+96mhXFJDtI=";
=======
    sha256 = "sha256-sE+HeXg6JovLXhFFJhgsASfObvzgeYX+MjwI5b7G0gI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-7ykVKPjCFwpLqdPiWlxO/rBofgbfv+U3aM50RhzjGVY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit Security ];

  cargoBuildFlags = [ "--package" "oxigraph_server" ];

  # requires packaging of the associated python modules
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/oxigraph/oxigraph";
    description = "SPARQL graph database";
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    maintainers = with maintainers; [ astro ];
    license = with licenses; [ asl20 mit ];
  };
}
