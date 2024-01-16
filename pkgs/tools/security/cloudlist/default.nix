{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-oq+JmcENFcB4AoVEhxoYIKZArgzVm6QFsPF8ybtNMak=";
  };

  vendorHash = "sha256-4eGmfPXqohdRHT0xExF1Z5jE8GscQGlVEmS3cHMX4x8=";

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    changelog = "https://github.com/projectdiscovery/cloudlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
