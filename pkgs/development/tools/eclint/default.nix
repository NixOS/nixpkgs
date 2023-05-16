{ lib
, buildGoModule
, fetchFromGitLab
}:

buildGoModule
rec {
  pname = "eclint";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "greut";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-/WSxhdPekCNgeWf+ObIOblCUj3PyJvykGyCXrFmCXLA=";
  };

  vendorHash = "sha256-hdMBd0QI2uWktBV+rH73rCnnkIlw2zDT9OabUuWIGks=";
=======
    sha256 = "sha256-wAT+lc8cFf9zOZ72EwIeE2z5mCjGN8vpRoS1k15X738=";
  };

  vendorHash = "sha256-6aIE6MyNDOLRxn+CYSCVNj4Q50HywSh/Q0WxnxCEtg8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://gitlab.com/greut/eclint";
    description = "EditorConfig linter written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
