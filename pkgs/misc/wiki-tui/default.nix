{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-maN/0lJx6/lj3Zn+IZcPJFPPFVLbnpwxeMSTyzKYX6s=";
  };

  # latest update forgot to include cargo.lock update
  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/Builditluc/wiki-tui/commit/87993eaca35a14afc1fb557482b099a6dd2da911.patch";
      sha256 = "sha256-n04FCZwQ9pPanz9QQY/7Apyoy6lG0t/23S40p4c/TXw=";
    })
  ];

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-x4oS9IBF2GMcilv9Oi/IeFaCM3sxWn7PpkKcaeSqIog=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
    mainProgram = "wiki-tui";
  };
}
