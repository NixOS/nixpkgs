{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GB+BAGIVPtyY2Bsm/yDTYjJixLGvGwsIoOLCyy/0AJk=";
  };

  vendorHash = "sha256-5LIIXf+8ZN7WcFSPzsJ5Tt+d40AgF5YI3O1oXms1WgI=";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
