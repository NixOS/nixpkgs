{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "infra";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "infrahq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4sExRKq4J94cQYqjxaXCKa2aEeptCG+TTvrDOrJfBUg=";
  };

  vendorSha256 = "sha256-afbQQsluZjgliNxSOGcTS1DJwj7en5NpxtuzCDAyv98=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Infra manages access to infrastructure such as Kubernetes";
    homepage = "https://github.com/infrahq/infra";
    changelog = "https://github.com/infrahq/infra/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
