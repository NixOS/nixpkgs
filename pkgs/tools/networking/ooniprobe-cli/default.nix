{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
<<<<<<< HEAD
  version = "3.18.1";
=======
  version = "3.17.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-abCglaMFW6zPc53IU8Bgl/SaoIh1N9i3xDcfOnJypls=";
  };

  vendorHash = "sha256-olirtvnOIKvNXJsanv5UFTcpj7RpPAa5OP0qYTv4wtk=";

  subPackages = [ "cmd/ooniprobe" ];

  ldflags = [ "-s" "-w" ];

=======
    hash = "sha256-2BsgSsIIQPzqTfoAunBkwrshZd22aI/AXFfz2tk3/78=";
  };

  vendorHash = "sha256-r8kyL9gpdDesY8Mbm4lONAhWC4We26Z9uG7QMt1JT9c=";

  subPackages = [ "cmd/ooniprobe" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    changelog = "https://github.com/ooni/probe-cli/releases/tag/${src.rev}";
    description = "The Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
