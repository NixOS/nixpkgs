{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kapp }:

buildGoModule rec {
  pname = "kapp";
<<<<<<< HEAD
  version = "0.58.0";
=======
  version = "0.55.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-kapp";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-E5QiR4hcO2Ii5qXAlMrw9Yxy8IYqjnonSGiUUyzhMVc=";
=======
    sha256 = "sha256-Y/2Jsb4S07Sp4RbCp9E0/VHfYejFN3cmBLaTqUSK/6Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  subPackages = [ "cmd/kapp" ];

  ldflags = [
    "-X github.com/vmware-tanzu/carvel-kapp/pkg/kapp/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kapp completion $shell > kapp.$shell
      installShellCompletion kapp.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = kapp;
  };

  meta = with lib; {
    description = "CLI tool that encourages Kubernetes users to manage bulk resources with an application abstraction for grouping";
    homepage = "https://get-kapp.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes ];
  };
}
