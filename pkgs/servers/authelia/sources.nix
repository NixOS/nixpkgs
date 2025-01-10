{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.38.18";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-gJEKjplESS6wNN2cM/JYRAHm7200tMlBKs1lZi0ShiE=";
  };
  vendorHash = "sha256-K5PunLkbcEuWL4IWbXYqgP3H5S/d5IHrWqCin//qJxw=";
  pnpmDepsHash = "sha256-jkghQGWLvmL1Vxwl7v4T/H1UUN8DeaCgbc8lnUcS4nA=";
}
