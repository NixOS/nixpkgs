{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "bearer";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    rev = "refs/tags/v${version}";
    hash = "sha256-ecLJvV2gUY6uUeCUsVtDSVOQnZnsThGtguWWzb4vsoE=";
  };

  vendorHash = "sha256-EHj7tpQoiwu9pocFg5chNpuekxM3bHE2+V2srD4bInQ=";

  subPackages = [
    "cmd/bearer"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

#  doCheck = false;

  meta = with lib; {
    description = "Code security scanning tool (SAST) to discover, filter and prioritize security and privacy risks";
    homepage = "https://github.com/bearer/bearer";
    changelog = "https://github.com/Bearer/bearer/releases/tag/v${version}";
    license = with licenses; [ elastic ];
    maintainers = with maintainers; [ fab ];
  };
}
