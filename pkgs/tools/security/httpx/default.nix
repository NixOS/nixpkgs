{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "httpx";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    rev = "v${version}";
    sha256 = "sha256-gBt1xllfzw8M+n+vgUmOQ3vgDxDuDaQ7YXfWdLWnpVk=";
  };

  vendorSha256 = "sha256-9ZwRbeZ1iSuJiIJDBauU1U9PpGn8QQPTd3MfrnSmF+w=";

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
