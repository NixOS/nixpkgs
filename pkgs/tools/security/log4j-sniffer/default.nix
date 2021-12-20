{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "log4j-sniffer";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dsuIeNAYe/iuxfezfs+hyyziFrE3M+GRxqYuawYFKDU=";
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
