{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "uncover";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FJtd73z6Cc56+nBderYncjrac3xRydDeoiJqn8xW29U=";
  };

  vendorHash = "sha256-mpojOzGedkTthD+fHl9Uhul7tOCN1EGIin+7USoaNmE=";

  meta = with lib; {
    description = "API wrapper to search for exposed hosts";
    longDescription = ''
      uncover is a go wrapper using APIs of well known search engines to quickly
      discover exposed hosts on the internet. It is built with automation in mind,
      so you can query it and utilize the results with your current pipeline tools.
      Currently, it supports shodan,shodan-internetdb, censys, and fofa search API.
    '';
    homepage = "https://github.com/projectdiscovery/uncover";
    changelog = "https://github.com/projectdiscovery/uncover/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
