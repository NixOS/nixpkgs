{ stdenv
, lib
, formats
, nixosTests
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, udev
, openssl
, sqlite
, pam
, bashInteractive
, rust-jemalloc-sys
}:

let
  arch = if stdenv.isx86_64 then "x86_64" else "generic";
in
rustPlatform.buildRustPackage rec {
  pname = "kanidm";
  version = "1.1.0-rc.16";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    # Latest revision of 1.1.0-rc.16 stable branch
    rev = "e51d0dee44ecabbf7be9e855753453bb2f61cced";
    hash = "sha256-YgrlmSrjOzn/oFWmYy/71xwcq53lJbmiLIFzn2sIFAk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "base64urlsafedata-0.1.3" = "sha256-lYVWuKqF4c34LpFmTIg98TEXIlP4dHen0XkGnLOiq8Q=";
      "sshkeys-0.3.2" = "sha256-CNG9HW8kSwezAdIYW+CR5rqFfmuso4R0+m4OpIyXbSM=";
    };
  };

  KANIDM_BUILD_PROFILE = "release_nixos_${arch}";

  postPatch =
    let
      format = (formats.toml { }).generate "${KANIDM_BUILD_PROFILE}.toml";
      profile = {
        admin_bind_path = "/run/kanidmd/sock";
        cpu_flags = if stdenv.isx86_64 then "x86_64_legacy" else "none";
        default_config_path = "/etc/kanidm/server.toml";
        default_unix_shell_path = "${lib.getBin bashInteractive}/bin/bash";
        web_ui_pkg_path = "@web_ui_pkg_path@";
      };
    in
    ''
      cp ${format profile} libs/profiles/${KANIDM_BUILD_PROFILE}.toml
      substituteInPlace libs/profiles/${KANIDM_BUILD_PROFILE}.toml \
        --replace '@web_ui_pkg_path@' "${placeholder "out"}/ui"
    '';

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    udev
    openssl
    sqlite
    pam
    rust-jemalloc-sys
  ];

  # The UI needs to be in place before the tests are run.
  postBuild = ''
    # We don't compile the wasm-part form source, as there isn't a rustc for
    # wasm32-unknown-unknown in nixpkgs yet.
    mkdir $out
    cp -r server/web_ui/pkg $out/ui
  '';

  preFixup = ''
    installShellCompletion \
      --bash $releaseDir/build/completions/*.bash \
      --zsh $releaseDir/build/completions/_*

    # PAM and NSS need fix library names
    mv $out/lib/libnss_kanidm.so $out/lib/libnss_kanidm.so.2
    mv $out/lib/libpam_kanidm.so $out/lib/pam_kanidm.so
  '';

  passthru.tests = { inherit (nixosTests) kanidm; };

  meta = with lib; {
    changelog = "https://github.com/kanidm/kanidm/releases/tag/v${version}";
    description = "A simple, secure and fast identity management platform";
    homepage = "https://github.com/kanidm/kanidm";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ erictapen Flakebi ];
  };
}
