{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "chaos";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "chaos-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-NA78zMge9AsfqO1px1FWCDKmWy1a0h8dtTotpgLazh4=";
  };

  vendorHash = "sha256-KkT/mgU1BOwJcjxOBMCMq0hyxZAyoh25bi+s3ka6TOg=";

  subPackages = [
    "cmd/chaos/"
  ];

  meta = with lib; {
    description = "Tool to communicate with Chaos DNS API";
    homepage = "https://github.com/projectdiscovery/chaos-client";
    changelog = "https://github.com/projectdiscovery/chaos-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
