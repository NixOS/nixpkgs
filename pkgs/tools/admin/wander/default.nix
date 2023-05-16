<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "wander";
  version = "0.11.1";
=======
{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, wander }:

buildGoModule rec {
  pname = "wander";
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-EIMHCal4jt8tMEfx2Lol2/7IK8uROaNC1ABB+0d0YTg=";
  };

  vendorHash = "sha256-SqDGXV8MpvEQFAkcE1NWvWjdzYsvbO5vA6k+hpY0js0=";

  ldflags = [ "-s" "-w" ];
=======
    sha256 = "sha256-g9QAdwAqy3OA+nYsSpVLUPv1gn6N12339fgmYFT6Iys=";
  };

  vendorHash = "sha256-iTaZ5/0UrLJ3JE3FwQpvjKKrhqklG4n1WFTJhWfj/rI=";

  ldflags = [ "-s" "-w" "-X=github.com/robinovitch61/wander/cmd.Version=v${version}" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd wander \
      --fish <($out/bin/wander completion fish) \
      --bash <($out/bin/wander completion bash) \
      --zsh <($out/bin/wander completion zsh)
  '';

<<<<<<< HEAD
=======
  passthru.tests.version = testers.testVersion {
    package = wander;
    command = "wander --version";
    version = "v${version}";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Terminal app/TUI for HashiCorp Nomad";
    license = licenses.mit;
    homepage = "https://github.com/robinovitch61/wander";
    maintainers = teams.c3d2.members;
  };
}
