{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, git
, python3
, makeWrapper
<<<<<<< HEAD
, writeScriptBin
, darwin
, which
=======
, darwin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "pylyzer";
<<<<<<< HEAD
  version = "0.0.43";
=======
  version = "0.0.26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mtshiba";
    repo = "pylyzer";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+h69AtuFBvqy/P6Qe5s0Ht66eXzg5KDs2ipoNyKludo=";
  };

  cargoHash = "sha256-Jqe3mswnbrfvUdQm4DfnCkJGksEuGzfuxNjEI7cEyQs=";
=======
    hash = "sha256-ZEmTSSYHQWk0IVJXlrtGb+j2hbb9ZtDLCtajOR7BMoU=";
  };

  cargoHash = "sha256-/QMzPvLcAjpai2YX58+YM/+KhYZRuK59hPYAEHeTTa4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    git
    python3
    makeWrapper
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
    (writeScriptBin "diskutil" "")
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mkdir -p $out/lib
    cp -r $HOME/.erg/ $out/lib/erg
  '';

<<<<<<< HEAD
  nativeCheckInputs = [
    which
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkFlags = [
    # this test causes stack overflow
    # > thread 'exec_import' has overflowed its stack
    "--skip=exec_import"
  ];

  postFixup = ''
    wrapProgram $out/bin/pylyzer --set ERG_PATH $out/lib/erg
  '';

  meta = with lib; {
    description = "A fast static code analyzer & language server for Python";
    homepage = "https://github.com/mtshiba/pylyzer";
    changelog = "https://github.com/mtshiba/pylyzer/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
