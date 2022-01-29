{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "log4j-sniffer";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ffutvIxXhA0fCN6mSUwv6F+SO/ab6hLiaVJeatZo57w=";
  };

  vendorSha256 = null;

  checkInputs = [
    git
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
    cd $HOME
    git init
  '';

  meta = with lib; {
    description = "Tool that scans archives to check for vulnerable log4j versions";
    homepage = "https://github.com/palantir/log4j-sniffer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
