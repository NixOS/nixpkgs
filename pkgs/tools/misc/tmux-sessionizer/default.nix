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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FSh3ww5KpktNSvqB3kcIaTxNHypwsVTHze0mgBtuJQE=";
  };

  cargoSha256 = "sha256-3DyLYegAzNbPpW6MUIDLm1QUqmGg8zH0Ps1dbdaSezs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "The fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
  };
}
