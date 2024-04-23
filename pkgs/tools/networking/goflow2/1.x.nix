{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goflow2";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ORLmo+AYIXVtoacbpuHQkTG+GaI1kjaCE52opMD905M=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-jWm/061alLKTzn53uKun1qj2TM77pjltQlZl1/dTd80=";

  meta = with lib; {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = licenses.bsd3;
    maintainers = teams.wdz.members;
    mainProgram = "goflow2";
  };
}
