{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, testers
, nats-top
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "nats-top";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-YQNIEhs/KNJp7184zBk0NZyXRWLQDaySZBJWe11vI9E=";
  };

  vendorHash = "sha256-IhaeM/stU9O48reT/mUadSkZDz0JXKCXjSRw8TMesTY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = nats-top;
      version = "v${version}";
    };
  };
=======
    hash = "sha256-ZSPv4meyIYqNJm6SvqnpOjTtRGvfkUOAxn3JHmK5UEQ=";
  };

  vendorHash = "sha256-8UcHRFt/O8RgZRxODIJZ16zvBi7FmadYdA/NUH9kfEo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    changelog = "https://github.com/nats-io/nats-top/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
