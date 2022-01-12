{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

with lib;

buildGoModule rec {
  pname = "kind";
  version = "0.11.1";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "sha256-pjg52ONseKNw06EOBzD6Elge+Cz+C3llPvjJPHkn1cw=";
  };

  patches = [
    # fix kernel module path used by kind
    ./kernel-module-path.patch
  ];

  vendorSha256 = "sha256-HiVdekSZrC/RkMSvcwm1mv6AE4bA5kayUsMdVCbckiE=";

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kind completion $shell > kind.$shell
      installShellCompletion kind.$shell
    done
  '';

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage    = "https://github.com/kubernetes-sigs/kind";
    maintainers = with maintainers; [ offline rawkode ];
    license     = lib.licenses.asl20;
    platforms   = platforms.unix;
  };
}
