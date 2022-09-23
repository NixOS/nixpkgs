{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "dnsx";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    rev = "v${version}";
    sha256 = "sha256-tcUVJ/qcQGivcAjWkcfv1fZxc9F5cYn1stpCHDoJRps=";
  };

  vendorSha256 = "sha256-hGV44Rx5kX2ZVBsTyeWm5SzpXzlTFNidt7bwzntboQo=";

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
