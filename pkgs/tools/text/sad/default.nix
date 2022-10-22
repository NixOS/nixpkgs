{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.22";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v1fXEC+bV561cewH17x+1anhfXstGBOHG5rHvhYIvLo=";
  };

  cargoSha256 = "sha256-krQTa9R3hmMVKLoBgnbCw+aSQu9HUXfA3XflB8AZv6w=";

  meta = with lib; {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
