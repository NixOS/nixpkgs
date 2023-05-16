{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, installShellFiles
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "aws-nuke";
<<<<<<< HEAD
  version = "2.25.0";
=======
  version = "2.21.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rebuy-de";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Yc9GXdcSKPvwddh+QU2/pBC0XIqA53wpd0VNKOqppbU=";
  };

  vendorHash = "sha256-FZ92JoyPYysYhl7iQZ8X32BDyNKL1UbOgq7EhHyqb5A=";

  nativeBuildInputs = [ installShellFiles ];

  overrideModAttrs = _: {
    preBuild = ''
      go generate ./...
    '';
  };
=======
    sha256 = "sha256-xROZGlQlbmeECLK3edfaCRIBB92gKjdQy2RpuFCiwsg=";
  };

  vendorSha256 = "sha256-un1H5fZSo6OZOS+Wn7B1Fbe7YbtF4lMj0dT1B9YhtNA=";

  preBuild = ''
    if [ "x$outputHashAlgo" != "x" ]; then
      # Only `go generate` when fetching the go mod vendor code
      go generate ./...
    fi
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "." ];

<<<<<<< HEAD
  ldflags = [ "-s" "-w" ];

  postInstall = ''
    installShellCompletion --cmd aws-nuke \
      --bash <($out/bin/aws-nuke completion bash) \
      --fish <($out/bin/aws-nuke completion fish) \
      --zsh <($out/bin/aws-nuke completion zsh)
  '';

  meta = with lib; {
    description = "Nuke a whole AWS account and delete all its resources";
    homepage = "https://github.com/rebuy-de/aws-nuke";
    changelog = "https://github.com/rebuy-de/aws-nuke/releases/tag/v${version}";
=======
  meta = with lib; {
    description = "Nuke a whole AWS account and delete all its resources";
    homepage = "https://github.com/rebuy-de/aws-nuke";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc ];
  };
}
