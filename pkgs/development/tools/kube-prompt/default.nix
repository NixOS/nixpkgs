{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kube-prompt";
  version = "1.0.11";
  rev = "v${version}";

  goPackagePath = "github.com/c-bata/kube-prompt";

  src = fetchFromGitHub {
    inherit rev;
    owner = "c-bata";
    repo = "kube-prompt";
    sha256 = "sha256-9OWsITbC7YO51QzsRwDWvojU54DiuGJhkSGwmesEj9w=";
  };

  subPackages = ["."];
  goDeps = ./deps.nix;

  meta = {
  description = "An interactive kubernetes client featuring auto-complete using go-prompt";
    license = lib.licenses.mit;
    homepage = "https://github.com/c-bata/kube-prompt";
    maintainers = [ lib.maintainers.vdemeester ];
  };
}
