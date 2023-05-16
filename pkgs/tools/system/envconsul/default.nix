<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, testers, envconsul }:

buildGoModule rec {
  pname = "envconsul";
  version = "0.13.2";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "envconsul";
  version = "0.13.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "envconsul";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-GZU1lEAI3k5EUU/z4gHR8plECudwp+YYyPSk7E0NQtI=";
  };

  vendorHash = "sha256-ehxeupO8CrKqkqK11ig7Pj4XTh61VOE4rT2T2SsChxw=";
=======
    sha256 = "sha256-9X0mSEMaLGdchf9g5EyRUsn7z6cvbG4QBPoaris7RwQ=";
  };

  vendorSha256 = "sha256-Vunq3lsM1aSXNIr3ZMqE03f0jEI5BpWwMYhZ41tiB9M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/envconsul/version.Name=envconsul"
  ];

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion {
    package = envconsul;
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/hashicorp/envconsul/";
    description = "Read and set environmental variables for processes from Consul";
=======
  meta = with lib; {
    homepage = "https://github.com/hashicorp/envconsul/";
    description = "Read and set environmental variables for processes from Consul";
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
