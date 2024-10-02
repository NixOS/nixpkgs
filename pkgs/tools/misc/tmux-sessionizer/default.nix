{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, openssl
, pkg-config
, Security
, testers
, tmux-sessionizer
}:
let

  name = "tmux-sessionizer";
  version = "0.4.2";

in
rustPlatform.buildRustPackage {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = name;
    rev = "v${version}";
    hash = "sha256-n6DXqsq3TsNob/fEqeOwNTVLPAvCr7CDN9qtXAiOMWQ=";
  };

  cargoHash = "sha256-e2U6x7HFoFbZxtJvY/ZpgEWagIrdRxPVZw2rP5aDIqg=";

  passthru.tests.version = testers.testVersion {
    package = tmux-sessionizer;
    version = version;
  };

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  meta = with lib; {
    description = "Fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller mrcjkb ];
    mainProgram = "tms";
  };
}
