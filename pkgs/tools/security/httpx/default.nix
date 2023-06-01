{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "httpx";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    rev = "refs/tags/v${version}";
    hash = "sha256-QTD8aPpsqfMcCWT+b4V5z6dIrVW86sVi5WqShN055P0=";
  };

  vendorHash = "sha256-rXzAZTJtX9RhUjqo+Xllnh00fBaQH1Yne+gKqmxLXUU=";

  subPackages = [ "cmd/httpx" ];

  ldflags = [ "-s" "-w" ];

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
