{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-8E4rciuoZrj8Oz2EXqtFgrPxvb8GJO3n1s2FpXrR0Q0=";
  };

  vendorSha256 = "sha256-scaaRjaDE/RG6Ei83CJBkfQCd1e5pH/Cs2vEbdl9Oyg=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
