{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nezha-agent";
  version = "0.15.17";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-ZoJqO555cQ2jl/ofEOgkorSPJ0H4MFtBFD8KktVvVus=";
  };

  vendorHash = "sha256-b2Wqr7j05jkWAIZ+y0abkybQtmEk881KuGwi5FoCdlA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  checkPhase = ''
    runHook preCheck
    export GOFLAGS=''${GOFLAGS//-trimpath/}
    rm ./pkg/monitor/myip_test.go
    for pkg in $(getGoDirs test); do
      buildGoDir test "$pkg"
    done
    runHook postCheck
  '';

  meta = with lib; {
    description = "Agent of Nezha Monitoring";
    homepage = "https://github.com/nezhahq/agent";
    license = licenses.asl20;
    maintainers = with maintainers; [ moraxyc ];
  };
}
