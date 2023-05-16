<<<<<<< HEAD
{ lib
, fetchFromGitHub
, buildGoModule
, testers
, clash
}:

buildGoModule rec {
  pname = "clash";
  version = "1.18.0";
=======
{ lib, fetchFromGitHub, buildGoModule, testers, clash }:

buildGoModule rec {
  pname = "clash";
  version = "1.15.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-LqjSPlPkR5sB4Z1pmpdE9r66NN7pwgE9GK4r1zSFlxs=";
  };

  vendorHash = "sha256-EWAbEFYr15RiJk9IXF6KaaX4GaSCa6E4+8rKL4/XG8Y=";
=======
    hash = "sha256-r74OL15stW+Io8+/cTGa98TVipM2sL4LnkZXHqa7CBE=";
  };

  vendorHash = "sha256-HS3VnQ9nkRy9OEfE1ASb3fhH/JlgUSlrVlGYNYwGmVA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Do not build testing suit
  excludedPackages = [ "./test" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

<<<<<<< HEAD
  checkFlags = [
    "-skip=TestParseRule" # Flaky tests
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.tests.version = testers.testVersion {
    package = clash;
    command = "clash -v";
  };

  meta = with lib; {
    description = "A rule-based tunnel in Go";
<<<<<<< HEAD
    homepage = "https://dreamacro.github.io/clash/";
    changelog = "https://github.com/Dreamacro/clash/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
    mainProgram = "clash";
=======
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
