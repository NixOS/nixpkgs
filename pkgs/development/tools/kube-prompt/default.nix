{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kube-prompt-${version}";
  version = "1.0.5";
  rev = "v${version}";

  goPackagePath = "github.com/c-bata/kube-prompt";

  src = fetchFromGitHub {
    inherit rev;
    owner = "c-bata";
    repo = "kube-prompt";
    sha256 = "1c1y0n1yxcaxvhlsj7b0wvhi934b5g0s1mi46hh5amb9j3dhgq1c";
  };

  goDeps = ./deps.nix;

  meta = {
  description = "An interactive kubernetes client featuring auto-complete using go-prompt";
    license = lib.licenses.mit;
    homepage = https://github.com/c-bata/kube-prompt;
    maintainers = [ lib.maintainers.vdemeester ];
  };
}
