{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxml2
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    sha256 = "sha256-bAUuNKaS0BQ31GxTd8C2EVZiD8ryevFBOfxLCq6Ccz4=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxml2
    openssl
  ];

  # Tests require network access to a test server
  doCheck = false;

  cargoSha256 = "sha256-dc1hu5vv2y4S1sskO7YN7bm+l2j5Jp5xOLMvXzX8Ago=";

  meta = with lib; {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format.";
    homepage = "https://hurl.dev/";
    maintainers = with maintainers; [ eonpatapon ];
    license = licenses.asl20;
  };
}
