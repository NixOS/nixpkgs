{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nginx-sso";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
    hash = "sha256-mJwUAMjFUSbJZ8o096o2ntfd7c7dNU+LbgbL/l8aDGc=";
  };

  vendorHash = "sha256-nyzcFYnUm2xxAdiy16vVyeF57zRI9D+P+/58pP6evDs=";

  postInstall = ''
    mkdir -p $out/share
    cp -R $src/frontend $out/share
  '';

  passthru.tests = {
    inherit (nixosTests) nginx-sso;
  };

  meta = with lib; {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = "https://github.com/Luzifer/nginx-sso";
    license = licenses.asl20;
    maintainers = with maintainers; [ delroth ];
    mainProgram = "nginx-sso";
  };
}
