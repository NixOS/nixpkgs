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
  version = "0.104.1";
in

rustPlatform.buildRustPackage {
  pname = "nushell";
  inherit version;

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    tag = version;
    hash = "sha256-ibQBwcoWzxl7t5q0KpiCiEmAasJJjBg2LMGf28y3sCk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8HxLX94i86F9vsnlZFgvVdTCkponlEA51WXCT3zlc2w=";

  nativeBuildInputs =
    [ pkg-config ]
    ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ python3 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs =
    [
      openssl
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      zlib
    ]
    ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isDarwin) [
      nghttp2
      libgit2
    ];

  buildNoDefaultFeatures = !withDefaultFeatures;
  buildFeatures = additionalFeatures [ ];

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
        --skip=repl::test_config_path::test_xdg_config_empty
    )
    runHook postCheck
  '';

  checkInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    curlMinimal
  ];

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
