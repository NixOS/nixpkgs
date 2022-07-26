{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpcui";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XDVt5fml2zYXOcZYXnxxGu4uaUA75DnRlFkbcc6tDag=";
  };

  vendorSha256 = "sha256-jHNjvh4rpZdQ/RC9gN3KXnuOLkJX8Ow5GV+Qwfyvx1o=";

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
