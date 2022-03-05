{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "dnsx";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    rev = "v${version}";
    sha256 = "sha256-8c9gDD/g5oP9GQV1ghb2UN9w5EccvxyDvJUAtgV8q7Y=";
  };

  vendorSha256 = "sha256-uvquc0bWwYzeeTuKlYaQp9r+O23MMs1Ajz1DPJ2qrnE=";

  meta = with lib; {
    description = "Fast and multi-purpose DNS toolkit";
    longDescription = ''
      dnsx is a fast and multi-purpose DNS toolkit allow to run multiple
      probers using retryabledns library, that allows you to perform
      multiple DNS queries of your choice with a list of user supplied
      resolvers.
    '';
    homepage = "https://github.com/projectdiscovery/dnsx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
