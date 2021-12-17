{ lib, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JhQkoVGJpMesNz2hRe+kWNX4zYrIcKzT0Z6owrXlRN4=";
  };

  cargoSha256 = "sha256-BikzJr50Aua9llyQgbP/paIoC7dvsG0RYyVXmbdeGIA=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlagsArray = [ "--skip=tests::cli" ];

  meta = with lib; {
    description = "Bundle any web page into a single HTML file";
    homepage = "https://github.com/Y2Z/monolith";
    license = licenses.unlicense;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
