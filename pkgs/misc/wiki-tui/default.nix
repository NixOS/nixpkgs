{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, nix-update-script, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TWpCmHG07dv0/hXGpo71Ie0uDRqs6yywHzcv0Hpi8Sc=";
  };

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-tJhbIsmh4zw1Dhvc2jE0N1cTE4//DOe3rDzDVNiTigA=";

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
