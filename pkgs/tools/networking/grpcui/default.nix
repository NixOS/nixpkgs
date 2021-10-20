{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpcui";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l8ldx7nx2pa2ac5znss0j0dhapn3syj02xqys4jz22hr5gvfj6m";
  };

  vendorSha256 = "15qgpbsl41swifw8w1lx0pbniwv3rf35127ald7h1r157vfa0r8b";

  doCheck = false;

  subPackages = [ "cmd/grpcui" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "An interactive web UI for gRPC, along the lines of postman";
    homepage = "https://github.com/fullstorydev/grpcui";
    license = licenses.mit;
    maintainers = with maintainers; [ pradyuman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
