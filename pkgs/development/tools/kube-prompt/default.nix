{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kube-prompt-${version}";
  version = "1.0.4";
  rev = "v${version}";

  goPackagePath = "github.com/c-bata/kube-prompt";

  src = fetchFromGitHub {
    inherit rev;
    owner = "c-bata";
    repo = "kube-prompt";
    sha256 = "09c2kjsk8cl7qgxbr1s7qd9br5shf7gccxvbf7nyi6wjiass9yg5";
  };

  goDeps = ./deps.nix;

  meta = {
  description = "An interactive kubernetes client featuring auto-complete using go-prompt";
    license = lib.licenses.mit;
    homepage = https://github.com/c-bata/kube-prompt;
    maintainers = [ lib.maintainers.vdemeester ];
  };
}
