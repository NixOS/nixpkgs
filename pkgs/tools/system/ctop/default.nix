{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctop";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = pname;
    rev = version;
    sha256 = "sha256-ceRyYrqmgdTnV8m9LkLlR6iTrC5F81X/V3fWI2CiKBw=";
  };

  vendorSha256 = "sha256-UCeMy4iT0c2sTcCDPg0TIYCLYfrIUvHluUuGIpzluSg=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.build=v${version}" ];

  meta = with lib; {
    description = "Top-like interface for container metrics";
    homepage = "https://ctop.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux marsam SuperSandro2000 ];
  };
}
