{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.6.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "oauth2-proxy";
    sha256 = "sha256-7DmeXl/aDVFdwUiuljM79CttgjzdTVsSeAYrETuJG0M=";
    rev = "v${version}";
  };

  vendorHash = "sha256-ihFNFtfiCGGyJqB2o4SMYleKdjGR4P5JewkynOsC1f0=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    maintainers = teams.serokell.members;
    mainProgram = "oauth2-proxy";
  };
}
