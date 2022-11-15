{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "uncover";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bYSqfxjJGue+7gPr8XgkcPF7UUuKWmLuQO07KCJp4jY=";
  };

  vendorSha256 = "sha256-FG0pqzSoqT/KjTOjXidAGjSABMFWgChJJYOhBfyzM7w=";

  meta = with lib; {
    description = "API wrapper to search for exposed hosts";
    longDescription = ''
      uncover is a go wrapper using APIs of well known search engines to quickly
      discover exposed hosts on the internet. It is built with automation in mind,
      so you can query it and utilize the results with your current pipeline tools.
      Currently, it supports shodan,shodan-internetdb, censys, and fofa search API.
    '';
    homepage = "https://github.com/projectdiscovery/uncover";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
