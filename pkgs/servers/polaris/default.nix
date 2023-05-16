{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
<<<<<<< HEAD
, nix-update-script
, polaris-web
, darwin
=======
, polaris-web
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "polaris";
<<<<<<< HEAD
  version = "0.14.0";
=======
  version = "0.13.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "agersant";
    repo = "polaris";
<<<<<<< HEAD
    rev = version;
    hash = "sha256-mLugPi3Xp46Lh48JQVeyOEGiovSF26gUt25MGBPFfkM=";
=======
    rev = "${version}";
    sha256 = "sp1KDTzKvcGtuqL37fFnVgcnkIsmj5ZQji72BeyiFQE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "id3-1.4.0" = "sha256-0j2iOd/GkMqLu18Eu8nttmqez0G6fu2m19gsHWMmLds=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.Security
  ];

  # Compile-time environment variables for where to find assets needed at runtime
  env = {
    POLARIS_WEB_DIR = "${polaris-web}/share/polaris-web";
    POLARIS_SWAGGER_DIR = "${placeholder "out"}/share/polaris-swagger";
  };
=======
  cargoSha256 = "sha256-0VHrlUoyYu+UTUQUioftBDlQJfLd/axz6bGJs+YXSmE=";

  # Compile-time environment variables for where to find assets needed at runtime
  POLARIS_WEB_DIR = "${polaris-web}/share/polaris-web";
  POLARIS_SWAGGER_DIR = "${placeholder "out"}/share/polaris-swagger";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mkdir -p $out/share
    cp -a docs/swagger $out/share/polaris-swagger
  '';

  preCheck = ''
    # 'Err' value: Os { code: 24, kind: Uncategorized, message: "Too many open files" }
    ulimit -n 4096
  '';

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };
=======
  passthru.updateScript = ./update.sh;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
  };
}
