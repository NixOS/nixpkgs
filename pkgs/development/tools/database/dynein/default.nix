{ fetchFromGitHub
, lib
, Security
, openssl
, pkg-config
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "dynein";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "dynein";
    rev = "v${version}";
    sha256 = "sha256-QhasTFGOFOjzNKdQtA+eBhKy51O4dFt6vpeIAIOM2rQ=";
  };

  # Use system openssl.
  OPENSSL_NO_VENDOR = 1;

  cargoHash = "sha256-QyhoYgqBfK6LCdtLuo0feVCgIMPueYeA8MMGspGLbGQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  preBuild = ''
    export OPENSSL_DIR=${lib.getDev openssl}
    export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib
  '';

  # The integration tests will start downloading docker image of DynamoDB, which
  # will naturally fail for nix build. The CLI tests do not need DynamoDB.
  cargoTestFlags = [ "cli_tests" ];

  meta = with lib; {
    description = "DynamoDB CLI written in Rust";
    mainProgram = "dy";
    homepage = "https://github.com/awslabs/dynein";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pimeys ];
  };
}
