{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix-update-script
, polaris-web
, darwin
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "polaris";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "agersant";
    repo = "polaris";
    tag = version;
    hash = "sha256-uwYNyco4IY6lF+QSVEOVVhZCJ4nRkj8gsgRA0UydLHU=";

    # The polaris version upstream in Cargo.lock is "0.0.0".
    # We're unable to simply patch it in the patch phase due to
    # rustPlatform.buildRustPackage fetching dependencies before applying patches.
    # If we patch it after fetching dependencies we get an error when
    # validating consistency between the final build and the prefetched deps.
    postFetch = ''
      # 'substituteInPlace' does not support multiline replacements?
      sed -i $out/Cargo.lock -z \
        -e 's/\[\[package\]\]\nname = "polaris"\nversion = "0.0.0"/[[package]]\nname = "polaris"\nversion = "'"${version}"'"/g'
    '';
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EUUxKLLdXgNp7GWTWAkzdNHKogu4Voo8wjeFFzM9iEg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.Security
  ];

  # Compile-time environment variables for where to find assets needed at runtime
  env = {
    POLARIS_WEB_DIR = "${polaris-web}/share/polaris-web";
  };

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
  passthru.updateScript = nix-update-script { };

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
}
