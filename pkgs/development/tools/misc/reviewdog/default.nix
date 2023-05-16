{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
<<<<<<< HEAD
  version = "0.15.0";
=======
  version = "0.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-EKDs0Xv38RLC3qDkb8QT3CMWdi7tEPRXxhlZiC/dyZo=";
  };

  vendorHash = "sha256-IKndnxeLy9hLFzs0SesRQzii9h8MX9FrEcpHaaKIq4k=";
=======
    sha256 = "sha256-6NsGTpVj6m0sUVhTPmgtfhGz11IfYjjAiRKETUhqf2w=";
  };

  vendorSha256 = "sha256-tdB/XPGr7pZeYZOkKH3XQggXtDUetkI75Ylu/E7ma64=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/reviewdog" ];

  ldflags = [ "-s" "-w" "-X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    homepage = "https://github.com/reviewdog/reviewdog";
<<<<<<< HEAD
    changelog = "https://github.com/reviewdog/reviewdog/blob/v${version}/CHANGELOG.md";
=======
    changelog = "https://github.com/reviewdog/reviewdog/raw/v${version}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
