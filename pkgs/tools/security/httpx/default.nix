{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "httpx";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    rev = "refs/tags/v${version}";
    hash = "sha256-FiCY9dZDZ92c6MayloS97Ff1trc5w4M/AIS6XORZf5U=";
  };

  vendorHash = "sha256-++vCyunRkLn9K1u+zXSN4TzIS9J8emc/w85ToqmG7gY=";

  subPackages = [
    "cmd/httpx"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Fast and multi-purpose HTTP toolkit";
    longDescription = ''
      httpx is a fast and multi-purpose HTTP toolkit allow to run multiple
      probers using retryablehttp library, it is designed to maintain the
      result reliability with increased threads.
    '';
    homepage = "https://github.com/projectdiscovery/httpx";
    changelog = "https://github.com/projectdiscovery/httpx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
