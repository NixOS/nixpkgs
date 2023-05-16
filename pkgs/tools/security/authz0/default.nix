{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "authz0";
<<<<<<< HEAD
  version = "1.1.2";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NrArxuhzd57NIdM4d9p/wfCB1e6l83pV+cjjCgZ9YtM=";
  };

  vendorHash = "sha256-ARPrArvCgxLdCaiUdJyjB/9GbbldnMXwFbyYubbsqxc=";
=======
    hash = "sha256-8WtvUeHP7fJ1/G+UB1QLCSSNx7XA+vREcwJxoMeQsgM=";
  };

  vendorSha256 = "sha256-EQhvHu/LXZtVQ+MzjB96K0MUM4THiRDe1FkAATfGhdw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Automated authorization test tool";
    homepage = "https://github.com/hahwul/authz0";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
