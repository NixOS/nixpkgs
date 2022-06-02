{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.20";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BhkSqXiQPOSYnCXqjAqenKx3DextxPluqsTAMI4Xs7g=";
  };

  cargoSha256 = "sha256-aKTF0DH8Lf/H6OfQPuQ6yGOmUEUguYcHMCuYKIjNR9k=";

  meta = with lib; {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
