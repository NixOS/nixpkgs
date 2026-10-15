{
  version = "2026.3";

  minKernelVersion = "5.15";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2026.3/$tool-2026.3.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-H4FQVIGqSIjpcRazdPKVOqQsJdoQYphGciadxZG7BDE=";
    batctl = "sha256-LIRD+uezRxpQCDf4z7vCt7urYC5DzoxhsQBWDewdnuA=";
    batman-adv = "sha256-w1JOfY8Uh4agUmVKexCQ45R0bTpx7l1lf5ht168WF2I=";
  };
}
