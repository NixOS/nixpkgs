<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nebula";
  version = "1.7.2";
=======
{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nebula";
  version = "1.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-/kEXrcMFnrnnD+6754EDoOvn4czh0rJGEjlXkmCzb1w=";
  };

  vendorHash = "sha256-VZzSdl8R1y7rCF2vz7e+5nAkb3wlJymNWCXwZZUvg4A=";
=======
    rev = "v${version}";
    sha256 = "sha256-IsLSlQsrfw3obkz4jHL23BRQY2fviGbPEvs5j0zkdX0=";
  };

  vendorSha256 = "sha256-GvMiOEC3Y/pGG++Z+XCgLVADKymUR9shDxjx3xIz8u0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/nebula" "cmd/nebula-cert" ];

  ldflags = [ "-X main.Build=${version}" ];

  passthru.tests = {
    inherit (nixosTests) nebula;
  };

  meta = with lib; {
<<<<<<< HEAD
    description = "Overlay networking tool with a focus on performance, simplicity and security";
=======
    description = "A scalable overlay networking tool with a focus on performance, simplicity and security";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      Nebula is a scalable overlay networking tool with a focus on performance,
      simplicity and security. It lets you seamlessly connect computers
      anywhere in the world. Nebula is portable, and runs on Linux, OSX, and
      Windows. (Also: keep this quiet, but we have an early prototype running
      on iOS). It can be used to connect a small number of computers, but is
      also able to connect tens of thousands of computers.

      Nebula incorporates a number of existing concepts like encryption,
      security groups, certificates, and tunneling, and each of those
      individual pieces existed before Nebula in various forms. What makes
      Nebula different to existing offerings is that it brings all of these
      ideas together, resulting in a sum that is greater than its individual
      parts.
    '';
    homepage = "https://github.com/slackhq/nebula";
<<<<<<< HEAD
    changelog = "https://github.com/slackhq/nebula/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne numinit ];
  };
=======
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne numinit ];
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
