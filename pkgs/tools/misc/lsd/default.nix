{ lib
<<<<<<< HEAD
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
=======
, fetchFromGitHub
, rustPlatform
, installShellFiles
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pandoc
, testers
, lsd
}:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
<<<<<<< HEAD
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lsd-rs";
    repo = "lsd";
    rev = "v${version}";
    hash = "sha256-syT+1LNdigUWkfJ/wkbY/kny2uW6qfpl7KmW1FjZKR8=";
  };

  cargoHash = "sha256-viLr76Bq9OkPMp+BoprQusMDgx59nbevVi4uxjZ+eZg=";

  nativeBuildInputs = [ installShellFiles pandoc ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

=======
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = pname;
    rev = version;
    sha256 = "sha256-FY1odcKBl7zJ+MxfohkmC1e45fPQK3MKB3orQdCRpA4=";
  };

  cargoSha256 = "sha256-t7J7hIbLlRq99Yd2/3Zn+PbHhJtaJRdDluDXN0Hp/Jc=";

  nativeBuildInputs = [ installShellFiles pandoc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    pandoc --standalone --to man doc/lsd.md -o lsd.1
    installManPage lsd.1

<<<<<<< HEAD
    installShellCompletion --cmd lsd \
      --bash $releaseDir/build/lsd-*/out/lsd.bash \
      --fish $releaseDir/build/lsd-*/out/lsd.fish \
      --zsh $releaseDir/build/lsd-*/out/_lsd
=======
    installShellCompletion $releaseDir/build/lsd-*/out/{_lsd,lsd.{bash,fish}}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = lsd;
  };

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://github.com/lsd-rs/lsd";
    description = "The next gen ls command";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam zowoq SuperSandro2000 ];
=======
    homepage = "https://github.com/Peltoche/lsd";
    description = "The next gen ls command";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne marsam zowoq SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
