{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, openssl
, zlib
, zstd
, pkg-config
, python3
, xorg
, Libsystem
, AppKit
, Security
, nghttp2
, libgit2
, withDefaultFeatures ? true
, additionalFeatures ? (p: p)
, testers
, nushell
, nix-update-script
, makeBinaryWrapper
, plugins ? []
}:

let
  version = "0.95.0";
in

rustPlatform.buildRustPackage {
  pname = "nushell";
  inherit version;

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = version;
    hash = "sha256-NxdqQ5sWwDptX4jyQCkNX2pVCua5nN4v/VYHZ/Q1LpQ=";
  };

  cargoHash = "sha256-PNZPljUDXqkyQicjwjaZsiSltxgO6I9/9VJDWKkvUFA=";

  nativeBuildInputs = [ pkg-config makeBinaryWrapper ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isLinux) [ python3 ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = [ openssl zstd ]
    ++ lib.optionals stdenv.isDarwin [ zlib Libsystem Security ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isDarwin) [ AppKit nghttp2 libgit2 ];

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

  postInstall = lib.optional (plugins != []) (
    let
      pluginRegistryPath = "$out/share/nushell/plugins.nu";
      pluginRegistrations = (map (p: ''$out/bin/nu --plugin-config ${pluginRegistryPath} -c "register ${p}/bin/${p.meta.mainProgram}"'') plugins);
    in
    ''
      mkdir -p "$(dirname ${pluginRegistryPath})"
      touch ${pluginRegistryPath}
      ${builtins.concatStringsSep "\n" pluginRegistrations}
      wrapProgram $out/bin/nu \
        --add-flags --plugin-config \
        --add-flags "${pluginRegistryPath}"
    '');

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
    maintainers = with maintainers; [ Br1ght0ne johntitor joaquintrinanes ];
    mainProgram = "nu";
  };
}
