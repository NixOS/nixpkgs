{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nginx-sso";
<<<<<<< HEAD
  version = "0.27.1";
=======
  version = "0.26.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mJwUAMjFUSbJZ8o096o2ntfd7c7dNU+LbgbL/l8aDGc=";
  };

  vendorHash = "sha256-nyzcFYnUm2xxAdiy16vVyeF57zRI9D+P+/58pP6evDs=";
=======
    hash = "sha256-vtbomeezW8PMv2lCR6PJqYw+PCFJ3M1SAQPGaIWouXY=";
  };

  vendorHash = "sha256-THTQhUgIfDDTgnR4qZxWFoGQzvqr3xrrz5ZxnV9ipBM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    mainProgram = "nginx-sso";
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
