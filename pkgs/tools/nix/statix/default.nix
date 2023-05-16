{ lib, rustPlatform, fetchFromGitHub, withJson ? true, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in
  # pkgs/applications/editors/vim/plugins/overrides.nix
  # the version can be found in flake.nix of the source code
<<<<<<< HEAD
  version = "0.5.8";
=======
  version = "0.5.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-bMs3XMiGP6sXCqdjna4xoV6CANOIWuISSzCaL5LYY4c=";
  };

  cargoSha256 = "sha256-QF7P0CWlKfBzVQC//eKhf/u1qV9AfLIJDxWDDWzMG8g=";
=======
    sha256 = "sha256-OQk80eTUufVUbYvZ38el2lmkgkU+5gr0hLTrBvzIp4A=";
  };

  cargoSha256 = "sha256-j+FcV5JtO66Aa0ncIUfjuWtqnMmFb7zW7rNXttYBUU4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildFeatures = lib.optional withJson "json";

  # tests are failing on darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/nerdypepper/statix";
    license = licenses.mit;
<<<<<<< HEAD
    mainProgram = "statix";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ figsoda nerdypepper ];
  };
}
