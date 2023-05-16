{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kind";
<<<<<<< HEAD
  version = "0.20.0";
=======
  version = "0.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
<<<<<<< HEAD
    sha256 = "sha256-5yDoxrsnmz8N0Y35juItLtyclTz+pSb75B1P716XPxU=";
=======
    sha256 = "sha256-ei0klTKLTyxhCkwhG/CSswFd1JPimCMR32pKwPYPvQU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # fix kernel module path used by kind
    ./kernel-module-path.patch
  ];

<<<<<<< HEAD
  vendorHash = "sha256-J/sJd2LLMBr53Z3sGrWgnWA8Ry+XqqfCEObqFyUD96g=";
=======
  vendorSha256 = "sha256-J/sJd2LLMBr53Z3sGrWgnWA8Ry+XqqfCEObqFyUD96g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  CGO_ENABLED = 0;
  GOFLAGS = [ "-trimpath" ];
  ldFlags = [ "-buildid=" "-w" ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kind completion $shell > kind.$shell
      installShellCompletion kind.$shell
    done
  '';

  meta = with lib; {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage    = "https://github.com/kubernetes-sigs/kind";
    maintainers = with maintainers; [ offline rawkode ];
    license     = licenses.asl20;
<<<<<<< HEAD
=======
    platforms   = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
