{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctop";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tojSzgpoGQg6MwV/MVpQpCA5w6bZO+9IOvfkw0Ydr6c=";
  };

  vendorHash = "sha256-UAja7XuoLqJFNcK1PgHGcuf/HbvSrWyRvW2D3T7Hg0g=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.build=v${version}" ];

  meta = with lib; {
    description = "Top-like interface for container metrics";
    homepage = "https://ctop.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux marsam ];
  };
}
