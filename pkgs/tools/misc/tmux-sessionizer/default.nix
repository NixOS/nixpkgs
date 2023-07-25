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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fV+LBs+jbcOjArUfygEXkyxg/xGhI35YduUkx4AyQhk=";
  };

  cargoHash = "sha256-Bg4C4r3h/kaMsAqzit9JVuAe7vYrRB9W5OLOWPgCJHc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "The fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
  };
}
