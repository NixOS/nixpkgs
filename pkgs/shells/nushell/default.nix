{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  zlib,
  zstd,
  pkg-config,
  python3,
  xorg,
  nghttp2,
  libgit2,
  withDefaultFeatures ? true,
  additionalFeatures ? (p: p),
  testers,
  nushell,
  nix-update-script,
  curlMinimal,
}:

let
  # NOTE: when updating this to a new non-patch version, please also try to
  # update the plugins. Plugins only work if they are compiled for the same
  # major/minor version.
  version = "0.106.1";
in
rustPlatform.buildRustPackage {
  pname = "nushell";
  inherit version;

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    tag = version;
    hash = "sha256-VrGsdO7RiTlf8JK3MBMcgj0z4cWUklDwikMN5Pu6JQI=";
  };

  cargoHash = "sha256-GSpR54QGiY9Yrs/A8neoKK6hMvSr3ORtNnwoz4GGprY=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ python3 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ zlib ]
  ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ xorg.libX11 ]
  ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isDarwin) [
    nghttp2
    libgit2
  ];

  buildNoDefaultFeatures = !withDefaultFeatures;
  buildFeatures = additionalFeatures [ ];

  preCheck = ''
    export NU_TEST_LOCALE_OVERRIDE="en_US.UTF-8"
  '';

  checkPhase = ''
    runHook preCheck
    (
      # The skipped tests all fail in the sandbox because in the nushell test playground,
      # the tmp $HOME is not set, so nu falls back to looking up the passwd dir of the build
      # user (/var/empty). The assertions however do respect the set $HOME.
      set -x
      HOME=$(mktemp -d) cargo test -j $NIX_BUILD_CORES --offline -- \
        --test-threads=$NIX_BUILD_CORES \
        --skip=repl::test_config_path::test_default_config_path \
        --skip=repl::test_config_path::test_xdg_config_bad \
        --skip=repl::test_config_path::test_xdg_config_empty ${lib.optionalString stdenv.hostPlatform.isDarwin ''
          \
                  --skip=plugins::config::some \
                  --skip=plugins::stress_internals::test_exit_early_local_socket \
                  --skip=plugins::stress_internals::test_failing_local_socket_fallback \
                  --skip=plugins::stress_internals::test_local_socket
        ''}
    )
    runHook postCheck
  '';

  checkInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [ curlMinimal ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  passthru = {
    shellPath = "/bin/nu";
    tests.version = testers.testVersion {
      package = nushell;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [
      Br1ght0ne
      johntitor
      joaquintrinanes
      ryan4yin
    ];
    mainProgram = "nu";
  };
}
