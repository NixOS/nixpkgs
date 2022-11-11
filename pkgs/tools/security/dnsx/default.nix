{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "dnsx";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    rev = "v${version}";
    sha256 = "sha256-5ZWBUgW3esdH+9APU5Z9Hn9VtA6VQqvUfJp5C42791k=";
  };

  vendorSha256 = "sha256-71JqgJZyx+9NTw08D7V5PPc84ExjGYdieCvFPTDSrs8=";

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
