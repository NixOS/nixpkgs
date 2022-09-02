{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vouch-proxy";
  version = "0.37.3";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    rev = "v${version}";
    sha256 = "sha256-zXt1Xo6xq1g1putx4q6z7SEXK4lNGRgRnNPXajL5Znw=";
  };

  vendorSha256 = "sha256-E1x1QTagXkL4NQ7REDuTHpUaadiz72e3jMLPVquSSV4=";

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
    maintainers = with maintainers; [ leona erictapen ];
    platforms = lib.platforms.linux;
  };
}
