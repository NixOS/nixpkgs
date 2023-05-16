{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
<<<<<<< HEAD
  version = "1.10.2";
=======
  version = "1.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2c1wSij2MDRdrqxN+cmnFO0z6mH/fgeg9E3cm+8ssww=";
  };

  cargoHash = "sha256-UXH0SstMVprgezyr3I/6rv2uCMdDUUSIsQ3MJ49tdoI=";
=======
    hash = "sha256-B0WfOvt037U56G9C7vfAVP4CElodszEUj8h/UD+qv4I=";
  };

  cargoHash = "sha256-EmNy7YjltUgPgAp/L/VjCVG2pu//o7Bq7v+B3vO5ipM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman Frostman ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
