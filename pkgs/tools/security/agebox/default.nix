{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "agebox";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "slok";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W6/v5BIl+k6tMan/Wdua7mHKMsq23QZN13Cy24akJr4=";
  };

  patches = [
    # Update gopkg.in/yaml.v2 to v2.2.8 to fix vulnerabilities.
    # https://github.com/slok/agebox/pull/199
    (fetchpatch {
      url = "https://github.com/slok/agebox/commit/40a515d39911f601ebe05cc914e8a02695d85dc7.patch";
      hash = "sha256-0iBI0nID12OoWqWY/8MPb3vvTUDe0JdSHu2vefix/bM=";
    })
  ];

  vendorHash = "sha256-MNAF2ExIOYPzXyGR6H7lfUEhnMDCyD7ecst5MKm7u+A=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/slok/agebox";
    changelog = "https://github.com/slok/agebox/releases/tag/v${version}";
    description = "Age based repository file encryption gitops tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
    mainProgram = "agebox";
  };
}
