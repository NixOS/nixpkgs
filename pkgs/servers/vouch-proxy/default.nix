{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vouch-proxy";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    rev = "v${version}";
    sha256 = "0rcc5b3v5d9v4y78z5fnjbn1k10xy8cpgxjhqc7j22k9wkic05mh";
  };

  vendorSha256 = "0pi230xcaf0wkphfn3s4h3riviihxlqwyb9lzfdvh8h5dpizxwc9";

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  # broken with go>1.16
  doCheck = false;

  preCheck = ''
    export VOUCH_ROOT=$PWD
  '';

  meta = with lib; {
    homepage = "https://github.com/vouch/vouch-proxy";
    description = "An SSO and OAuth / OIDC login solution for NGINX using the auth_request module";
    license = licenses.mit;
    maintainers = with maintainers; [ em0lar erictapen ];
    platforms = lib.platforms.linux;
  };
}
