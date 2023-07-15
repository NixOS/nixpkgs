{ stdenv
, lib
, formats
, nixosTests
, rustPlatform
, fetchFromGitHub
, fetchpatch
, installShellFiles
, pkg-config
, udev
, openssl
, sqlite
, pam
}:

let
  arch = if stdenv.isx86_64 then "x86_64" else "generic";
in
rustPlatform.buildRustPackage rec {
  pname = "kanidm";
  version = "1.1.0-alpha.12";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "f5924443f08e462067937a5dd0e2c19e5e1255da";
    hash = "sha256-kJUxVrGpczIdOqKQbgRp1xERfKP6C0SDQgWdjtSuvZ8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tracing-forest-0.1.5" = "sha256-L6auSKB4DCnZBZpx7spiikhSOD6i1W3erc3zjn+26Ao=";
    };
  };

  KANIDM_BUILD_PROFILE = "release_nixos_${arch}";

  patches = [
    (fetchpatch {
      # Bring back x86_64-v1 microarchitecture level
      name = "cpu-opt-level.patch";
      url = "https://github.com/kanidm/kanidm/commit/59c6723f7dfb2266eae45c3b2ddd377872a7a113.patch";
      hash = "sha256-8rVEYitxvdVduQ/+AD/UG3v+mgT/VxkLoxNIXczUfCQ=";
    })
  ];

  postPatch =
    let
      format = (formats.toml { }).generate "${KANIDM_BUILD_PROFILE}.toml";
      profile = {
        web_ui_pkg_path = "@web_ui_pkg_path@";
        cpu_flags = if stdenv.isx86_64 then "x86_64_legacy" else "none";
      };
    in
    ''
      cp ${format profile} libs/profiles/${KANIDM_BUILD_PROFILE}.toml
      substituteInPlace libs/profiles/${KANIDM_BUILD_PROFILE}.toml \
        --replace '@web_ui_pkg_path@' "$out/ui"
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
    description = "A simple, secure and fast identity management platform";
    homepage = "https://github.com/kanidm/kanidm";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ erictapen Flakebi ];
  };
}
