{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zkar";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "phith0n";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TGqsiYZLbXvCc30OtvNbX4INlzw3ZfjvXal47rP7NDw=";
  };

  vendorHash = "sha256-HQ9qclaaDj0H8PL0oQG1WsH19wVQpynijHNcal4gWBE=";

  meta = with lib; {
    description = "Java serialization protocol analysis tool";
    homepage = "https://github.com/phith0n/zkar";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
