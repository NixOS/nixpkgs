{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-dork";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tFmXutX3UnKAFFS4mO4PCv7Bhw1wJ7qjdA1ROryqYZU=";
  };

  vendorHash = "sha256-6V58RRRPamBMDAf0gg4sQMQkoD5dWauCFtPrwf5EasI=";

  meta = with lib; {
    description = "Dork scanner";
    homepage = "https://github.com/dwisiswant0/go-dork";
    changelog = "https://github.com/dwisiswant0/go-dork/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
