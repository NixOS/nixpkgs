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
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pljMWAfmDQUxQEyFGVhXqLjRq6P7D+YUB/e1h66WnDE=";
  };

  cargoSha256 = "sha256-kFDyjiupjN1cuhzE16v6JP/yyXdtwL3srZVtSimnahA=";

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
