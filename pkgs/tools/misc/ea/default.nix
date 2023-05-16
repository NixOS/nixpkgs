<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, installShellFiles
, libiconv
}:
=======
{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

rustPlatform.buildRustPackage rec {
  pname = "ea";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "ea";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-VXSSe5d7VO3LfjumzN9a7rrKRedOtOzTdLVQWgV1ED8=";
  };

  cargoPatches = [
    # https://github.com/dduan/ea/pull/64
    (fetchpatch {
      name = "update-guard.patch";
      url = "https://github.com/dduan/ea/commit/068aa36d7a472c7a4bac855f2404e7094dec7d58.patch";
      hash = "sha256-iK3fjB6zSDqe0yMUIFjP1nEFLYLFg7dy6+b0T6mC1GA=";
    })
  ];

  cargoHash = "sha256-/MkLWAbEr14CYdqSwJP1vNYxK7pAmMLdhiV61UQEbME=";

  nativeBuildInputs = [ installShellFiles ];

=======
    sha256 = "VXSSe5d7VO3LfjumzN9a7rrKRedOtOzTdLVQWgV1ED8=";
  };

  cargoSha256 = "sha256-YP7OJaIWTXJHe3qF+a3zCFnCHnELX0rAWqnJPaC1T7I=";

  nativeBuildInputs = [ installShellFiles ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  postInstall = ''
    installManPage docs/ea.1
  '';

  meta = with lib; {
    description = "Makes file paths from CLI output actionable";
    homepage = "https://github.com/dduan/ea";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ deejayem ];
  };
}
