{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, installShellFiles
, pkg-config
, openssl
, stdenv
, CoreServices
, Libsystem
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "rye";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "rye";
    rev = "refs/tags/${version}";
    hash = "sha256-btgX1nDBJeZjwv2pBi4OEwzFf7xpRDaq63JTrSkF+BM=";
  };

  patches = [
    (fetchpatch {  # Fixes the build: https://github.com/mitsuhiko/rye/issues/575
      name = "bump-monotrail";
      url = "https://github.com/mitsuhiko/rye/commit/675255c2c12176fff8988b6c3896dcd10766b681.patch";
      hash = "sha256-kBqjTHW7oT6DY17bdReoRfV9E75QtYqBlOv4FHbbexw=";
    })
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dialoguer-0.10.4" = "sha256-WDqUKOu7Y0HElpPxf2T8EpzAY3mY8sSn9lf0V0jyAFc=";
      "monotrail-utils-0.0.1" = "sha256-h2uxWsDrU9j2C5OWbYsfGz0S1VsPzYrfksQVEkwd2ys=";
    };
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isDarwin [
    CoreServices
    Libsystem
    SystemConfiguration
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rye \
      --bash <($out/bin/rye self completion -s bash) \
      --fish <($out/bin/rye self completion -s fish) \
      --zsh <($out/bin/rye self completion -s zsh)
  '';

  checkFlags = [
    "--skip=utils::test_is_inside_git_work_tree"
  ];

  meta = with lib; {
    description = "A tool to easily manage python dependencies and environments";
    homepage = "https://github.com/mitsuhiko/rye";
    changelog = "https://github.com/mitsuhiko/rye/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "rye";
  };
}
