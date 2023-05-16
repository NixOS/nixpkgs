{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, cmake
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, git
, nixosTests
, Security
, Foundation
, Cocoa
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
<<<<<<< HEAD
  version = "1.16.0";
=======
  version = "1.14.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-CrD65nHE40n83HO+4QM1sLHvdFaqTvOb96hPBgXKuwk=";
=======
    hash = "sha256-t+Ur6QmemMz6WAZnii7f2O+9R7hPp+5oej4PuaifznE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ installShellFiles cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security Foundation Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "-framework" "AppKit" ];

  postInstall = ''
    installShellCompletion --cmd starship \
      --bash <($out/bin/starship completions bash) \
      --fish <($out/bin/starship completions fish) \
      --zsh <($out/bin/starship completions zsh)
  '';

<<<<<<< HEAD
  cargoHash = "sha256-ZHHrpepKZnSGufyEAjNDozaIKAt2GFRt+hU2ej7LceA=";
=======
  cargoHash = "sha256-NSUId0CXTRF1Qqo9XPDgxY2vMyMBuJtJYGGuQ0HHk90=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [ git ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = with lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras danth davidtwco Br1ght0ne Frostman marsam ];
<<<<<<< HEAD
    mainProgram = "starship";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
