{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "safe";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "starkandwayne";
    repo = "safe";
    rev = "v${version}";
    sha256 = "sha256-i8L7L06nBIiwrMEF5+jwCm2/iox6W+yE1HcruB6EQNM=";
  };

  vendorSha256 = "sha256-w8gHCqOfmZg4JZgg1nZBtTJ553Rbp0a0JsoQVDFjehM=";

  subPackages = [ "." ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "A Vault CLI";
    homepage = "https://github.com/starkandwayne/safe";
    license = licenses.mit;
    maintainers = with maintainers; [ eonpatapon ];
  };
}
