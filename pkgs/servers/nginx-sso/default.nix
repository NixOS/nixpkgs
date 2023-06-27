{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nginx-sso";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
    hash = "sha256-vtbomeezW8PMv2lCR6PJqYw+PCFJ3M1SAQPGaIWouXY=";
  };

  vendorHash = "sha256-THTQhUgIfDDTgnR4qZxWFoGQzvqr3xrrz5ZxnV9ipBM=";

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
  };
}
