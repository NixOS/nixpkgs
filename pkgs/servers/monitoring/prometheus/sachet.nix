{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sachet";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "messagebird";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-zcFViE1/B+wrkxZ3YIyfy2IBbxLvXOf8iK/6eqZb1ZQ=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-zcFViE1/B+wrkxZ3YIyfy2IBbxLvXOf8iK/6eqZb1ZQ=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "An SMS alerting tool for Prometheus's Alertmanager";
    homepage = "https://github.com/messagebird/sachet";
    license = licenses.bsd2;
    maintainers = with maintainers; [ govanify ];
  };
}
