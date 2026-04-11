{
  version = "2026.1";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2026.1/$tool-2026.1.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-Rd+8uKfLuq7j4SYHpGYB3YbOUiUHJTXptJ2kC78CtIk=";
    batctl = "sha256-hEQWhsHUTtV6Vg8qC+n4brksMQ8iqqSgCTPrbIk2CHo=";
    batman-adv = "sha256-ZIfdO0rQ+FUQ3tu6M1/nexuHfQ53OTxR3coHp0Ubj0U=";
  };
}
