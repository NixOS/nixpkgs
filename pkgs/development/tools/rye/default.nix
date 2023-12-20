{ lib
, rustPlatform
, fetchFromGitHub
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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "rye";
    rev = "refs/tags/${version}";
    hash = "sha256-AIM61JEgWMDjeZVnOVamBiCXTT5LLEktwQpRtnflgcw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dialoguer-0.10.4" = "sha256-WDqUKOu7Y0HElpPxf2T8EpzAY3mY8sSn9lf0V0jyAFc=";
      "monotrail-utils-0.0.1" = "sha256-4x5jnXczXnToU0QXpFalpG5A+7jeyaEBt8vBwxbFCKQ=";
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
