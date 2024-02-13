{ stdenv
, fetchFromGitLab
, lib
, darwin
, nettle
, nix-update-script
, rustPlatform
, pkg-config
, openssl
, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-sq";
  version = "0.32.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sq";
    rev = "v${version}";
    hash = "sha256-2a6LIW5ohSi7fbMwk/wmNJ0AOz5JIXiXJI7EoVKv1Sk=";
  };

  cargoHash = "sha256-beA0viJVDjfANsPegkc/x2syVp8uGKTMnrPcM7jcvG4=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    nettle
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security SystemConfiguration ]);

  # Sometimes, tests fail on CI (ofborg) & hydra without this
  checkFlags = [
    # doctest for sequoia-ipc fail for some reason
    "--skip=macros::assert_send_and_sync"
    "--skip=macros::time_it"
  ];

  # Install manual pages, see https://gitlab.com/sequoia-pgp/sequoia-sq#building
  postInstall = ''
    mkdir -p $out/share/man
    SQ_MAN=$out/share/man/man1 cargo run
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A cool new OpenPGP implementation";
    homepage = "https://sequoia-pgp.org/";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-sq/-/blob/v${version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ minijackson doronbehar ];
    mainProgram = "sq";
  };
}
