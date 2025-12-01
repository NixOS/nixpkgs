{
  version,
  hash,
  cargoHash,
  unsupported ? false,
  eolDate ? null,
  patches ? [ ],
}:

{
  stdenv,
  lib,
  formats,
  nixosTests,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  pkg-config,
  udev,
  openssl,
  sqlite,
  pam,
  bashInteractive,
  rust-jemalloc-sys,
  kanidmWithSecretProvisioning,
  # If this is enabled, kanidm will be built with two patches allowing both
  # oauth2 basic secrets and admin credentials to be provisioned.
  # This is NOT officially supported (and will likely never be),
  # see https://github.com/kanidm/kanidm/issues/1747.
  # Please report any provisioning-related errors to
  # https://github.com/oddlama/kanidm-provision/issues/ instead.
  enableSecretProvisioning ? false,
}:

let
  arch = if stdenv.hostPlatform.isx86_64 then "x86_64" else "generic";

  versionUnderscored =
    finalAttrs: lib.replaceStrings [ "." ] [ "_" ] (lib.versions.majorMinor finalAttrs.version);

  upgradeNote = ''
    Please upgrade by verifying `kanidmd domain upgrade-check` and choosing the
    next version with `services.kanidm.package = pkgs.kanidm_1_x;`

    See upgrade guide at https://kanidm.github.io/kanidm/master/server_updates.html
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanidm" + (lib.optionalString enableSecretProvisioning "-with-secret-provisioning");
  inherit version cargoHash;

  cargoDepsName = "kanidm";

  src = fetchFromGitHub {
    owner = "kanidm";
    repo = "kanidm";
    tag = "v${finalAttrs.version}";
    inherit hash;
  };

  env.KANIDM_BUILD_PROFILE = "release_nixpkgs_${arch}";

  patches =
    patches
    ++ lib.optionals enableSecretProvisioning [
      (./. + "/provision-patches/${versionUnderscored finalAttrs}/oauth2-basic-secret-modify.patch")
      (./. + "/provision-patches/${versionUnderscored finalAttrs}/recover-account.patch")
    ];

  postPatch =
    let
      format = (formats.toml { }).generate "${finalAttrs.env.KANIDM_BUILD_PROFILE}.toml";
      socket_path = if stdenv.hostPlatform.isLinux then "/run/kanidmd/sock" else "/var/run/kanidm.socket";
      profile = {
        cpu_flags = if stdenv.hostPlatform.isx86_64 then "x86_64_legacy" else "none";
      }
      // lib.optionalAttrs (lib.versionAtLeast finalAttrs.version "1.5") {
        client_config_path = "/etc/kanidm/config";
        resolver_config_path = "/etc/kanidm/unixd";
        resolver_unix_shell_path = "${lib.getBin bashInteractive}/bin/bash";
        server_admin_bind_path = socket_path;
        server_config_path = "/etc/kanidm/server.toml";
        server_ui_pkg_path = "@htmx_ui_pkg_path@";
      }
      // lib.optionalAttrs (lib.versionAtLeast finalAttrs.version "1.8") {
        resolver_service_account_token_path = "/etc/kanidm/token";
      };
    in
    ''
      cp ${format profile} libs/profiles/${finalAttrs.env.KANIDM_BUILD_PROFILE}.toml
      substituteInPlace libs/profiles/${finalAttrs.env.KANIDM_BUILD_PROFILE}.toml --replace-fail '@htmx_ui_pkg_path@' "$out/ui/hpkg"
    '';

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    sqlite
    pam
    rust-jemalloc-sys
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  # The UI needs to be in place before the tests are run.
  postBuild = ''
    mkdir -p $out/ui
    cp -r server/core/static $out/ui/hpkg
  '';

  # Upstream runs with the Rust equivalent of -Werror,
  # which breaks when we upgrade to new Rust before them.
  # Just allow warnings. It's fine, really.
  env.RUSTFLAGS = "--cap-lints warn";

  # Not sure what pathological case it hits when compiling tests with LTO,
  # but disabling it takes the total `cargo check` time from 40 minutes to
  # around 5 on a 16-core machine.
  cargoTestFlags = [
    "--config"
    ''profile.release.lto="off"''
  ];

  preFixup = ''
    installShellCompletion \
      --bash $releaseDir/build/completions/*.bash \
      --zsh $releaseDir/build/completions/_* \
      --fish $releaseDir/build/completions/*.fish
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # PAM and NSS need fix library names
    mv $out/lib/libnss_kanidm.so $out/lib/libnss_kanidm.so.2
    mv $out/lib/libpam_kanidm.so $out/lib/pam_kanidm.so
  '';

  passthru = {
    tests = {
      kanidm = nixosTests.kanidm.extend {
        modules = [ { _module.args.kanidmPackage = finalAttrs.finalPackage; } ];
      };
      kanidm-provisioning = nixosTests.kanidm-provisioning.extend {
        modules = [ { _module.args.kanidmPackage = finalAttrs.finalPackage.withSecretProvisioning; } ];
      };
    };

    updateScript = lib.optionals (!enableSecretProvisioning) (nix-update-script {
      extraArgs = [
        "-vr"
        "v(${lib.versions.major finalAttrs.version}\\.${lib.versions.minor finalAttrs.version}\\.[0-9]*)"
        "--override-filename"
        "pkgs/servers/kanidm/${versionUnderscored finalAttrs}.nix"
      ];
    });

    inherit enableSecretProvisioning;
    # Unfortunately there is no such thing as finalAttrs.finalPackage.override,
    # so we have to resort to this.
    withSecretProvisioning = kanidmWithSecretProvisioning;

    eolMessage = lib.optionalString (eolDate != null) ''
      kanidm ${lib.versions.majorMinor finalAttrs.version} is deprecated and will reach end-of-life on ${eolDate}

      ${upgradeNote}
    '';
  };

  # can take over 4 hours on 2 cores and needs 16GB+ RAM
  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    changelog = "https://github.com/kanidm/kanidm/releases/tag/v${finalAttrs.version}";
    description = "Simple, secure and fast identity management platform";
    homepage = "https://github.com/kanidm/kanidm";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      adamcstephens
      Flakebi
    ];
    knownVulnerabilities = lib.optionals unsupported [
      ''
        kanidm ${lib.versions.majorMinor finalAttrs.version} has reached end-of-life.

        ${upgradeNote}
      ''
    ];
  };
})
