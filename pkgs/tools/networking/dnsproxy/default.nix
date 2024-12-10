{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.71.1";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "dnsproxy";
    rev = "v${version}";
    hash = "sha256-g+QjGU+9//Ms7s61IzkxLTffmu1XIhzUX841e86JqE4=";
  };

  vendorHash = "sha256-8t1/XIjDXRHumHkRNxQBeexL2qN94AHModk8ioLpMNY=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/AdguardTeam/dnsproxy/internal/version.version=${version}"
  ];

  # Development tool dependencies; not part of the main project
  excludedPackages = [ "internal/tools" ];

  doCheck = false;

  meta = with lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      contrun
      diogotcorreia
    ];
    mainProgram = "dnsproxy";
  };
}
