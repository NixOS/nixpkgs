{ lib
, fetchFromGitLab
, nettle
, nix-update-script
, installShellFiles
, rustPlatform
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-sqop";
  version = "0.33.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    # From some reason the repository is not sequoia-sqop - like the command
    # generated etc
    repo = "sequoia-sop";
    rev = "v${version}";
    hash = "sha256-5XK5Cec6ojrpIncAtlp9jYr9KxmNYJKPhbsJraA0FA0=";
  };

  cargoHash = "sha256-8ujQyG9qLuG8vjHoRtvpn4ka/Ft39u+NoxSZrD9NsfY=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    nettle
  ];
  buildFeatures = [ "cli" ];

  # Install manual pages
  postInstall = ''
    mkdir -p $out/share/man
    cp -r man-sqop $out/share/man/man1
    installShellCompletion --cmd sqop \
      --bash target/*/release/build/sequoia-sop*/out/sqop.bash \
      --fish target/*/release/build/sequoia-sop*/out/sqop.fish \
      --zsh target/*/release/build/sequoia-sop*/out/_sqop
    # Also elv and powershell are generated there
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An implementation of the Stateless OpenPGP Command Line Interface using Sequoia";
    homepage = "https://docs.sequoia-pgp.org/sqop/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "sqop";
  };
}
