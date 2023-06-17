{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_tileserv";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pNm802DJu5t+Y9QZU6wDUcAVpJTZ4SxDK0J61wzuuRE=";
  };

  vendorSha256 = "sha256-iw9bIh1Ngj5IGhrZwmSPciyaAR73msZ283TB0ibwt+c=";

  ldflags = [ "-s" "-w" "-X main.programVersion=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "A very thin PostGIS-only tile server in Go";
    homepage = "https://github.com/CrunchyData/pg_tileserv";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
