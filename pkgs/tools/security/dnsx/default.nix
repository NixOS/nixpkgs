{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dnsx";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    rev = "refs/tags/v${version}";
    hash = "sha256-gfznhNW9EmUuKrgxhQD4jKO4raQedTsg/ZcpscymQTs=";
  };

  vendorHash = "sha256-/fZaUJHP5HwwLBdeNq6iMhfdJ1DYt6YVeHP4ZGmYffg=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Fast and multi-purpose DNS toolkit";
    longDescription = ''
      dnsx is a fast and multi-purpose DNS toolkit allow to run multiple
      probers using retryabledns library, that allows you to perform
      multiple DNS queries of your choice with a list of user supplied
      resolvers.
    '';
    homepage = "https://github.com/projectdiscovery/dnsx";
    changelog = "https://github.com/projectdiscovery/dnsx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
