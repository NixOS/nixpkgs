{
  version = "2025.5";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2025.5/$tool-2025.5.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-dcEsHDw5zbIkb2H8pdTZ9h4kD+KCcSn6t6A97vhV/+g=";
    batctl = "sha256-HgvNSfku7aDXa8aDVirfNmAk4u5MGZ+kAgNva5PLsUc=";
    batman-adv = "sha256-GtvoI5kelxjjB/N2bqlkBf4fKEwZvLmMZi16H6oyTDU=";
  };
}
