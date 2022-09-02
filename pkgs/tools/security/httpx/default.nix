{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "httpx";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    rev = "v${version}";
    sha256 = "sha256-w4VELxmahqjfiMGXflSnhp5NKPi3HUucjxEUegljbVY=";
  };

  vendorSha256 = "sha256-9zLZyXrLvxwwkTwtpKxdGftzCZISZ/al98VnPiaMqGA=";

  meta = with lib; {
    description = "Fast and multi-purpose HTTP toolkit";
    longDescription = ''
      httpx is a fast and multi-purpose HTTP toolkit allow to run multiple
      probers using retryablehttp library, it is designed to maintain the
      result reliability with increased threads.
    '';
    homepage = "https://github.com/projectdiscovery/httpx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
