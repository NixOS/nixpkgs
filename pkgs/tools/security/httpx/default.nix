{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "httpx";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    rev = "v${version}";
    sha256 = "sha256-E7HGE+ZVUF6AK+4qVsO2t+/B8hRMd14/bZW2WXA6p6E=";
  };

  vendorSha256 = "sha256-VBxGapvC2QE/0slsAiCBzmwOSMeGepZU0pYVDepSrwg=";

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
