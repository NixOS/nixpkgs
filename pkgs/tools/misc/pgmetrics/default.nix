{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WzyTLOJo/wTZA9glxO0ovcaADlHV+AKLChWSLJ+uvaQ=";
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
