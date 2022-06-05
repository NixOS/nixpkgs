{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.2.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "oauth2-proxy";
    sha256 = "sha256-8hYsyHq0iyWzY/HHE4JWBtlaRcSTyM6BdAPcByThme8=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-+5/j2lZJpyo67uRRSn4Fd8S2K0gfAGMe69OoEEdWijc=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    maintainers = teams.serokell.members;
  };
}
