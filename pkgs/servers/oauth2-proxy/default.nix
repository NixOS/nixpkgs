{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.3.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "oauth2-proxy";
    sha256 = "sha256-GeJRB57CR719Vo1SWk1HYmTR1WEqokMZsUqGO2r0j0Q=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-sFb3hrjG/Msa29LVicaaAS7LYjDfBsq2DhUwyFQRrSs=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    maintainers = teams.serokell.members;
  };
}
