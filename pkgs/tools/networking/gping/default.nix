{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
<<<<<<< HEAD
, installShellFiles
, libiconv
, Security
, iputils
=======
, libiconv
, Security
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
<<<<<<< HEAD
  version = "1.14.0";
=======
  version = "1.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
<<<<<<< HEAD
    hash = "sha256-ReP+s2p0X39LVvl3/QF7fsYkU+OvsQyMhyuH8v4HuVU=";
  };

  cargoHash = "sha256-FTiNxCoEe/iMz68F1CpJHypgrhn4WwwWowuN9I1rl6E=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = lib.optionals stdenv.isLinux [ iputils ];

  postInstall = ''
    installManPage gping.1
  '';

=======
    sha256 = "sha256-hAUmRUMhP3rD1k6UhIN94/Kt+OjaytUTM3XIcrvasco=";
  };

  cargoSha256 = "sha256-SqQsKTS3psF/xfwyBRQB9c3/KIZU1fpyqVy9fh4Rqkk=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/gping --version | grep "${version}"
  '';

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
<<<<<<< HEAD
    changelog = "https://github.com/orf/gping/releases/tag/gping-v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
