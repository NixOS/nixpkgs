{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "hoard";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Hyde46";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xXZ1bbCRhS8/rb1eIErvw2wEWF1unLXSP/YKn5Z4Vwo=";
  };

  buildInputs = [ ncurses openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-c60yxbZG258R5iH6x0LhipbyXal/kDxddEzTfl82hCE=";

  meta = with lib; {
    description = "CLI command organizer written in rust";
    homepage = "https://github.com/hyde46/hoard";
    license = licenses.mit;
    maintainers = with maintainers; [ builditluc ];
  };
}
