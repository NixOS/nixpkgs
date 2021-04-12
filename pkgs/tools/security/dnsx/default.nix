{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "dnsx";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    rev = "v${version}";
    sha256 = "sha256-CjWFXYU34PE4I9xihQbPxVcxLyiMCYueuaB/LaXhHQg=";
  };

  vendorSha256 = "sha256-vTXvlpXpFf78Cwxq/y6ysSeXM3g71kHBn9zd6c4mxlk=";

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
