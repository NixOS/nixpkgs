{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8qL6ryCbCdHA9Zl/yScQ8tJh+i0Vr4JeH+fQYGb+wPE=";
  };

  cargoSha256 = "sha256-E7uuvE2xVyAiDfMEFbvVHt4agPEEt7JwF+SRFe+fqYk=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
