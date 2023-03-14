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
}:

let
  arch = if stdenv.isx86_64 then "x86_64" else "generic";
in
rustPlatform.buildRustPackage rec {
  pname = "kanidm";
  version = "1.1.0-alpha.10";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "fb76326234bffd9c9f3f24808d113f2c335c86fe";
    hash = "sha256-nE3zyigorAbDp5mgXzoyXWGOG+GaFC//SS/7Z9zj1Ps=";
  };

  cargoSha256 = "sha256-/CcmKYPtBHNdhJnO0OmZtW/39HH58qmCE9hFbIiNsaE=";

  KANIDM_BUILD_PROFILE = "release_nixos_${arch}";

  postPatch =
    let
      format = (formats.toml { }).generate "${KANIDM_BUILD_PROFILE}.toml";
      profile = {
        web_ui_pkg_path = "@web_ui_pkg_path@";
        cpu_flags = if stdenv.isx86_64 then "x86_64_v1" else "none";
      };
    in
    ''
      cp ${format profile} profiles/${KANIDM_BUILD_PROFILE}.toml
      substituteInPlace profiles/${KANIDM_BUILD_PROFILE}.toml \
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
    cp -r kanidmd_web_ui/pkg $out/ui
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
