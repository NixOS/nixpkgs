{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix-update-script
, polaris-web
, fetchpatch
, darwin
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "polaris";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "agersant";
    repo = "polaris";
    rev = version;
    hash = "sha256-UC66xRL9GyTPHJ3z0DD/yyI9GlyqelCaHHDyl79ptJg=";

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

  cargoPatches = [
    (fetchpatch { # https://github.com/agersant/polaris/pull/213
      name = "bump-time-crate.patch";
      url = "https://github.com/agersant/polaris/commit/f625c57d203bdd3f2d7fcd99ccce1032f04d9b91.patch";
      hash = "sha256-ICScYbSv4sCMbfZN2thhZMXGPcDX89xIhZqBJpGOzrY=";
    })
  ];

  cargoHash = "sha256-PnNLSL6YIpM6b3+oCh2eNRNPpCKyvnWEW7uNaYTKzAU=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.Security
  ];

  # Compile-time environment variables for where to find assets needed at runtime
  env = {
    POLARIS_WEB_DIR = "${polaris-web}/share/polaris-web";
    POLARIS_SWAGGER_DIR = "${placeholder "out"}/share/polaris-swagger";
  };

  postInstall = ''
    mkdir -p $out/share
    cp -a docs/swagger $out/share/polaris-swagger
  '';

  preCheck = ''
    # 'Err' value: Os { code: 24, kind: Uncategorized, message: "Too many open files" }
    ulimit -n 4096
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests = nixosTests.polaris;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Self-host your music collection, and access it from any computer and mobile device";
    longDescription = ''
      Polaris is a FOSS music streaming application, designed to let you enjoy your music collection
      from any computer or mobile device. Polaris works by streaming your music directly from your
      own computer, without uploading it to a third-party. There are no  kind of premium version.
      The only requirement is that your computer stays on while it streams your music!
    '';
    homepage = "https://github.com/agersant/polaris";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
    platforms = platforms.unix;
    mainProgram = "polaris";
  };
}
