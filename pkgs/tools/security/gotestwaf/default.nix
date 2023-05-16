{ lib
, buildGoModule
, fetchFromGitHub
, gotestwaf
, testers
}:

buildGoModule rec {
  pname = "gotestwaf";
<<<<<<< HEAD
  version = "0.4.3";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "wallarm";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-NalXG4I4BtDU7vfKb4H3gJERDQ92Y/46OWIgdg+7+MA=";
=======
    rev = "v${version}";
    hash = "sha256-waYX7DMyLW0eSzpFRyiCJQdYLFGaAKSlvGYrdcRfCl4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  # Some tests require networking as of v0.4.0
  doCheck = false;

  ldflags = [
<<<<<<< HEAD
    "-X=github.com/wallarm/gotestwaf/internal/version.Version=v${version}"
=======
    "-X github.com/wallarm/gotestwaf/internal/version.Version=v${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postFixup = ''
    # Rename binary
    mv $out/bin/cmd $out/bin/${pname}
  '';

  passthru.tests.version = testers.testVersion {
    command = "gotestwaf --version";
    package = gotestwaf;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Tool for API and OWASP attack simulation";
    homepage = "https://github.com/wallarm/gotestwaf";
<<<<<<< HEAD
    changelog = "https://github.com/wallarm/gotestwaf/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
