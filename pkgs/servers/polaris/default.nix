{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  darwin,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polaris";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "agersant";
    repo = "polaris";
    tag = finalAttrs.version;
    hash = "sha256-7VgDySL3LWEuf9ee+w3Wpv3WCNA7DBYFaMMmP7BE/rc=";
  };

  web-assets = callPackage ./web.nix { };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/YvLcawEBpF76evByQ0WMZ9dic5vFcsydbO/6TfN+ts=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.Security
  ];

  # Compile-time environment variables for where to find assets needed at runtime
  env.POLARIS_WEB_DIR = "${finalAttrs.web-assets}/share/polaris-web";

  preCheck = ''
    # 'Err' value: Os { code: 24, kind: Uncategorized, message: "Too many open files" }
    ulimit -n 4096
    # to debug bumps
    export RUST_BACKTRACE=1
  '';

  checkFlags = [
    # requires network
    "--skip=server::test::settings::put_settings_golden_path"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests.nixos = nixosTests.polaris;
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "web-assets"
    ];
  };

  meta = {
    description = "Self-host your music collection, and access it from any computer and mobile device";
    longDescription = ''
      Polaris is a FOSS music streaming application, designed to let you enjoy your music collection
      from any computer or mobile device. Polaris works by streaming your music directly from your
      own computer, without uploading it to a third-party. There are no  kind of premium version.
      The only requirement is that your computer stays on while it streams your music!
    '';
    homepage = "https://github.com/agersant/polaris";
    changelog = "https://github.com/agersant/polaris/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
    platforms = lib.platforms.unix;
    mainProgram = "polaris";
  };
})
