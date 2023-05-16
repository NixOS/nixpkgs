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
<<<<<<< HEAD
, bashInteractive
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  arch = if stdenv.isx86_64 then "x86_64" else "generic";
in
rustPlatform.buildRustPackage rec {
  pname = "kanidm";
<<<<<<< HEAD
  version = "1.1.0-beta.13";
=======
  version = "1.1.0-alpha.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
<<<<<<< HEAD
    # Latest 1.1.0-beta.13 tip
    rev = "5d1e2f90e6901017ab3ef9b5fbc10e25a5451fd2";
    hash = "sha256-70yeHVOrCuC+H96UC84kly3CCQ+y1RGzF5K/2FIag/o=";
  };

  cargoHash = "sha256-Qdc+E5+k9NNE4s6eAnpkam56pc2JJPahkuT4lB328cY=";
=======
    rev = "refs/tags/v${version}";
    hash = "sha256-TVGLL1Ir/Nld0kdhWmcYYmChrW42ctJPY/U7wtuEwCo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tracing-forest-0.1.4" = "sha256-ofBLxSzZ5SYy8cbViVUa6VXKbOgd8lt7QUYhL0BW6I4=";
    };
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  KANIDM_BUILD_PROFILE = "release_nixos_${arch}";

  postPatch =
    let
      format = (formats.toml { }).generate "${KANIDM_BUILD_PROFILE}.toml";
      profile = {
<<<<<<< HEAD
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
=======
        web_ui_pkg_path = "@web_ui_pkg_path@";
        cpu_flags = if stdenv.isx86_64 then "x86_64_v1" else "none";
      };
    in
    ''
      cp ${format profile} profiles/${KANIDM_BUILD_PROFILE}.toml
      substituteInPlace profiles/${KANIDM_BUILD_PROFILE}.toml \
        --replace '@web_ui_pkg_path@' "$out/ui"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  ];

  # The UI needs to be in place before the tests are run.
  postBuild = ''
    # We don't compile the wasm-part form source, as there isn't a rustc for
    # wasm32-unknown-unknown in nixpkgs yet.
    mkdir $out
<<<<<<< HEAD
    cp -r server/web_ui/pkg $out/ui
=======
    cp -r kanidmd_web_ui/pkg $out/ui
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/kanidm/kanidm/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A simple, secure and fast identity management platform";
    homepage = "https://github.com/kanidm/kanidm";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ erictapen Flakebi ];
  };
}
