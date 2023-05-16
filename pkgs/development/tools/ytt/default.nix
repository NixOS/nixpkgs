<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ytt";
  version = "0.45.4";
=======
{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "ytt";
  version = "0.45.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-ytt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-mv0o0Wyfpzifl7yqQy8AWKlzUlr3S4IdYVzwsf17boM=";
=======
    sha256 = "sha256-YfRr3oQUuDGVrQvfUzqld4SNWOsmGP4jmo5gf8tG6Vo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

<<<<<<< HEAD
  nativeBuildInputs = [ installShellFiles ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ldflags = [
    "-X github.com/vmware-tanzu/carvel-ytt/pkg/version.Version=${version}"
  ];

  subPackages = [ "cmd/ytt" ];

<<<<<<< HEAD
  postInstall = ''
    installShellCompletion --cmd ytt \
      --bash <($out/bin/ytt completion bash) \
      --fish <($out/bin/ytt completion fish) \
      --zsh <($out/bin/ytt completion zsh)
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "YAML templating tool that allows configuration of complex software via reusable templates with user-provided values";
    homepage = "https://get-ytt.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes techknowlogick ];
  };
}
