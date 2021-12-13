{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SU8byylr/Rv4lDWkt9+U4UvgCM5kYZeRsTk+hdz0y8w=";
  };

  cargoSha256 = "sha256-snc5QSaxbnXo6FOceqYucjN+ECo+RonejXda9Fvgggc=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
