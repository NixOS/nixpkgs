{ lib, rustPlatform, fetchFromGitHub, stdenv, openssl, perl, pkg-config, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "convco";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eWe7oTWl7QfIqq3GfMILi5S8zUi03ER1Mzfr8hqUvgw=";
  };

  cargoSha256 = "sha256-RuClZ+ChP7d40e9nr1Lg8R0F7rbFbBse79V9Y1AQn3o=";

  nativeBuildInputs = [ openssl perl pkg-config ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "A Conventional commit cli";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}
