{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Uwi21dNhpDhrcLS2Ra0vaRsvdqEz7FX7SPILeq12ZnE=";
  };

  vendorHash = "sha256-BGm3LvKOtlba/BtZ4Ue3Tzphlj5ZSqSzXTF8gSgRYEU=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
