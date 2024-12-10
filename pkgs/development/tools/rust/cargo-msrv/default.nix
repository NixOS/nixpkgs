{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  rustup,
  openssl,
  stdenv,
  libiconv,
  Security,
  makeWrapper,
  gitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-msrv";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rmWPkxxrpVamYHII0xkZq62ubL3/jrcqXUvFH9VuNtg=";
  };

  cargoSha256 = "sha256-/Bspy94uIP/e4uJY8qo+UPK1tnPjglxiMWeYWx2qoHk=";

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };
  };

  # Integration tests fail
  doCheck = false;

  buildInputs =
    if stdenv.isDarwin then
      [
        libiconv
        Security
      ]
    else
      [ openssl ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # Depends at run-time on having rustup in PATH
  postInstall = ''
    wrapProgram $out/bin/cargo-msrv --prefix PATH : ${lib.makeBinPath [ rustup ]};
  '';

  meta = with lib; {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    mainProgram = "cargo-msrv";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      otavio
      matthiasbeyer
    ];
  };
}
