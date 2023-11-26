{ fetchFromGitHub, buildGoModule, lib }:

buildGoModule rec {
  pname = "traefik-certs-dumper";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-o5nTxTyLuKtWcJvcWZuVwK970DMJfEaJw8vDcShulr0=";
  };

  vendorHash = "sha256-rBSRZ7gKUx3tBXqhkTOmAyEx9pLw41/Bt3O+AiHqXpw=";
  excludedPackages = "integrationtest";

  meta = with lib; {
    description = "dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
