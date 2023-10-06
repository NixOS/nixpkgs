{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.5.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "oauth2-proxy";
    sha256 = "sha256-zIw30pFf/IxruG3MYwrrLhANBPemLsYdYnPRO+EWNs0=";
    rev = "v${version}";
  };

  vendorHash = "sha256-Z2yPfUkDb07db8T3/1v9onnNloaKEN5tdrMDNIy7QHo=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    maintainers = teams.serokell.members;
  };
}
