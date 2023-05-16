{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "intermodal";
<<<<<<< HEAD
  version = "0.1.13";
=======
  version = "0.1.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-hKMO7ZicXSYESXWKmDC2ILD996KoYDXS5HJExyXMdX4=";
  };

  cargoHash = "sha256-7vtUMG6mxAHKnbouyTsaUf1myJssxYoqAIOjc6m86Fo=";
=======
    hash = "sha256-yPyKo2j0Up8gDzi2xOBqpMwIw6rpXDCxc8fCuEblwFY=";
  };

  cargoHash = "sha256-inJZTP4YwCZZ0JvSdGWnZbLN0A0B/+fz4g0XsfIQeq8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # include_hidden test tries to use `chflags` on darwin
  checkFlagsArray = lib.optionals stdenv.isDarwin [ "--skip=subcommand::torrent::create::tests::include_hidden" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd imdl \
      --bash <($out/bin/imdl completions bash) \
      --fish <($out/bin/imdl completions fish) \
      --zsh  <($out/bin/imdl completions zsh)
  '';

  meta = with lib; {
    description = "User-friendly and featureful command-line BitTorrent metainfo utility";
    homepage = "https://github.com/casey/intermodal";
<<<<<<< HEAD
    changelog = "https://github.com/casey/intermodal/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.cc0;
    maintainers = with maintainers; [ Br1ght0ne xrelkd ];
    mainProgram = "imdl";
  };
}
