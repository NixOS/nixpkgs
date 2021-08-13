{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "httpx";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    rev = "v${version}";
    sha256 = "sha256-uuHvU/KUHliY3FUwknp7ninKTY9qs+gI7WljgIvJEF4=";
  };

  vendorSha256 = "sha256-/xip2lwmpaSvnQoGj3de8Tgeog+HPrI8mF6catC1O4s=";

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
