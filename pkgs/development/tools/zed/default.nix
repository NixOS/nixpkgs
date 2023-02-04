{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-er3BPQ10ERCIBn0xx0jjyMBybnUBMyX76tqYEYe2WYQ=";
  };

  vendorHash = "sha256-3PyyR9d5m33ohbcstREvTOtWwMIrbFNvFyBY1F+6R+4=";

  subPackages = [ "cmd/zed" "cmd/zq" ];

  meta = with lib; {
    description = "A novel data lake based on super-structured data";
    homepage = "https://github.com/brimdata/zed";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
    changelog = "https://github.com/brimdata/zed/blob/v${version}/CHANGELOG.md";
  };
}
