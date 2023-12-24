{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tmux-sessionizer";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZascTDIV9MqPPtK0CHSXUW5gIk/zjRhUB0xATcu7ICM=";
  };

  cargoHash = "sha256-lZi72OJ+AnnLxf/zxwAERfy1oW8dE8bGF8hFwwrUXqE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "The fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller mrcjkb ];
    mainProgram = "tms";
  };
}
