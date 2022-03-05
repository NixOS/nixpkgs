{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IMNHsmL1L+zfGxfdTxJ4HBGiQOzWmYVE0P3ZInbMVl0=";
  };

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-Q8Xl6L41cDeDN370owAAL9xZhdyUuDKrPlZxG3eg87c=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
  };
}
