{ lib, fetchurl, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "1.0.5";
  src = fetchurl {
    url = "https://tratt.net/laurie/src/${pname}/releases/${pname}-${version}.tgz";
    hash = "sha256-fXvzltoY1sHdJ2u7WM1Qp/cMSYQ/o1P6LT5Deo+HnJU=";
  };
  cargoHash = "sha256-Lp5ovkQKShgT7EFvQ+5KE3eQWJEQAL68Bk1d+wUo+bc=";

  meta = with lib; {
    description = "A simple program for requesting, showing, and refreshing OAuth2 access tokens.";
    homepage = "https://tratt.net/laurie/src/pizauth/";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.pwoelfel ];
    platforms = platforms.linux;
  };
}
