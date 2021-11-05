{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aCfYb5UvlWbBvBlwNjVIbOJlEV2b3+FD0qKO+9h5Nos=";
  };

  buildInputs = [ ncurses openssl ];

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-dD8iC/b6KwElmq0RNdnHHC/jMWh7Q0/kMM+/zityHqQ=";

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
    mainProgram = "wiki-tui";
  };
}
