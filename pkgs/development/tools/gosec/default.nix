{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Yb0NEvGx0Ds3t2VjhSWw4oILmN1kR9Dlqe45/VRbu0A=";
  };

  vendorHash = "sha256-yphsGkubJyXDrlCAKh9tdKI5cDldNXvJ22fs3rY5I4Y=";

  subPackages = [
    "cmd/gosec"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.GitTag=${src.rev}"
    "-X main.BuildDate=unknown"
  ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    mainProgram = "gosec";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
  };
}
