{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.5";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-6DxMyCmH4D9wScUmx7o153jLEJJ7UtuNtwlOn8eG3pk=";
  };
  vendorHash = "sha256-QQStCdNFgw44USTejB5o7nupH5/FXVefLkh79BlKfk0=";
  pnpmDepsHash = "sha256-uRGsixN6Y4+fLcFLoofWOiQZegliy91YQEjVYm8ajMk=";
}
