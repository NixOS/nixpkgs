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
  ...
}@args:

let
  # NOTE: when updating this to a new non-patch version, please also try to
  # update the plugins. Plugins only work if they are compiled for the same
  # major/minor version.
  version = "0.108.0";
  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    tag = version;
    hash = "sha256-8OMTscMObV+IOSgOoTSzJvZTz6q/l2AjrOb9y3p2tZY=";
  };

in
rustPlatform.buildRustPackage {
  pname = "nushell";
  inherit version src;

  cargoHash = "sha256-M2wkhhaS3bVhwaa3O0CUK5hL757qFObr7EDtBFXXwxg=";

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
    export HOME=$(mktemp -d)
  '';

  NU_TEST_LOCALE_OVERRIDE = "en_US.UTF-8";
  # Set the correct profile to use during the `build.rs` stage of `checkPhase`
  NUSHELL_CARGO_PROFILE = args.checkType or "release";
  # These check flags can be removed in 0.109.0 (nushell/nushell#16914)
  checkFlags = [
    "--skip=repl::test_config_path::test_default_config_path"
    "--skip=repl::test_config_path::test_xdg_config_bad"
    "--skip=repl::test_config_path::test_xdg_config_empty"
  ];

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
