{ stdenv
, fetchFromGitLab
, lib
, nettle
, nix-update-script
, rustPlatform
, pkg-config
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-sqv";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sqv";
    rev = "v${version}";
    hash = "sha256-KoB9YnPNE2aB5MW5G9r6Bk+1QnANVSKA2dp3ufSJ44M=";
  };

  cargoHash = "sha256-uwOU/yyh3eoD10El7Oe9E97F3dvPuXMHQhpnWEJ1gnI=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    nettle
  ];
  # Otherwise, the shell completion files are not built
  cargoBuildFlags = [
    "--package" "sequoia-sqv"
  ];
  # Use a predictable target directory, to access it when installing shell
  # completion files.
  preBuild = ''
    export CARGO_TARGET_DIR="$(pwd)/target"
  '';
  postInstall = ''
    installShellCompletion --cmd sqv \
      --zsh target/_sqv \
      --bash target/sqv.bash \
      --fish target/sqv.fish
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A command-line OpenPGP signature verification tool";
    homepage = "https://docs.sequoia-pgp.org/sqv/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "sqv";
  };
}
