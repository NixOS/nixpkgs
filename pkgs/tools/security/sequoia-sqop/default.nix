{ stdenv
, fetchFromGitLab
, lib
, nettle
, nix-update-script
, installShellFiles
, rustPlatform
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-sqop";
  version = "0.28.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    # From some reason the repository is not sequoia-sqop - like the command
    # generated etc
    repo = "sequoia-sop";
    rev = "v${version}";
    hash = "sha256-4A0eZMXzFtojRD5cXQQUVoS32sQ2lWtFll+q6yhnwG4=";
  };

  cargoHash = "sha256-gH5WM+PmciViD+eFVlp8tzdc0KdYy1WZLQi92UEWVG4=";

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
