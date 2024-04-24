{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "safe";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "starkandwayne";
    repo = "safe";
    rev = "v${version}";
    sha256 = "sha256-sg0RyZ5HpYu7M11bNy17Sjxm7C3pkQX3I17edbALuvU=";
  };

  vendorHash = "sha256-w8gHCqOfmZg4JZgg1nZBtTJ553Rbp0a0JsoQVDFjehM=";

  subPackages = [ "." ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "A Vault CLI";
    mainProgram = "safe";
    homepage = "https://github.com/starkandwayne/safe";
    license = licenses.mit;
    maintainers = with maintainers; [ eonpatapon ];
  };
}
