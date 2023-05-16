{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromSourcehut
, rustPlatform
, installShellFiles
, scdoc
<<<<<<< HEAD
, Security
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "stargazer";
  version = "1.0.5";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "stargazer";
    rev = version;
    hash = "sha256-n88X3RJD7PqOcVRK/bp/gMNLVrbwnJ2iwi2rCpsfp+o=";
  };

  cargoHash = "sha256-Yqh3AQIOahKz2mLeVNm58Yr6vhjU4aQwN62y3Z5/EJc=";

  doCheck = false; # Uses extenal testing framework that requires network

  nativeBuildInputs = [ installShellFiles scdoc ];

<<<<<<< HEAD
  buildInputs = lib.optional stdenv.isDarwin Security;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    scdoc < doc/stargazer.scd  > stargazer.1
    scdoc < doc/stargazer-ini.scd  > stargazer.ini.5
    installManPage stargazer.1
    installManPage stargazer.ini.5
    installShellCompletion completions/stargazer.{bash,zsh,fish}
  '';

  meta = with lib; {
    description = "A fast and easy to use Gemini server";
    homepage = "https://sr.ht/~zethra/stargazer/";
    license = licenses.agpl3Plus;
    changelog = "https://git.sr.ht/~zethra/stargazer/refs/${version}";
    maintainers = with maintainers; [ gaykitty ];
<<<<<<< HEAD
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
