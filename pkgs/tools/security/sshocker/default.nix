{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sshocker";
<<<<<<< HEAD
  version = "0.3.3";
=======
  version = "0.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "sshocker";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Z1Dg+AeyfFmUDc3jV8/tOcUrxuyInfwubzo0cLpfFl8=";
  };

  vendorHash = "sha256-ceQzYByJNXr02IDBKhYuqnKfaTbnX5T03p2US4HRu6I=";
=======
    hash = "sha256-u/H9X0YbjVFK8IMUmL6OdarP/ojqXjZAHI+k61Ja++w=";
  };

  vendorHash = "sha256-WcPKMF8KNx7zlsdTnFf8vnW/uZZL1F4JWqMK7+qmyCk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lima-vm/sshocker/pkg/version.Version=${version}"
  ];

  meta = with lib; {
    description = "Tool for SSH, reverse sshfs and port forwarder";
    homepage = "https://github.com/lima-vm/sshocker";
    changelog = "https://github.com/lima-vm/sshocker/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
