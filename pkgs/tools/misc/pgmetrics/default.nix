{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8pF3E0Zh/SsH6+5iXt1KFwud2ijoisYfcu+QHRM9x9s=";
  };

  vendorHash = "sha256-KIMnvGMIipuIFPTSeERtCfvlPuvHvEHdjBJ1TbT2d1s=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
