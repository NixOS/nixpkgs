{ lib
, rustPlatform
, fetchFromGitHub
<<<<<<< HEAD
, nix-update-script
=======
, gitUpdater
, common-updater-scripts
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, makeWrapper
, rr
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rr";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "danielzfranklin";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-t8pRqeOdaRVG0titQhxezT2aDjljSs//MnRTTsJ73Yo=";
  };

  cargoSha256 = "sha256-P4r4XRolORdSGAsNg5RutZ2VVRR8rAfiBZNm+vIH3aM=";

  passthru = {
    updateScript = nix-update-script { };
=======
    sha256 = "sha256-lQS+bp1u79iO8WGrkZSFEuonr1eYjxIQYhUvM/kBao4";
  };

  cargoSha256 = "sha256-PdKqWMxTtBJbNqITs3IjNcpijXy6MHitEY4jDp4jZro=";

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-rr --prefix PATH : ${lib.makeBinPath [ rr ]}
  '';

  meta = with lib; {
    description = "Cargo subcommand \"rr\": a light wrapper around rr, the time-travelling debugger";
    homepage = "https://github.com/danielzfranklin/cargo-rr";
    license = with licenses; [ mit ];
<<<<<<< HEAD
    maintainers = with maintainers; [ otavio matthiasbeyer ];
=======
    maintainers = with maintainers; [ otavio ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
