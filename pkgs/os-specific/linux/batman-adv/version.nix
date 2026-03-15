{
  version = "2026.0";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2026.0/$tool-2026.0.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash to-sri --type sha256; done
  # ```
  sha256 = {
    batman-adv = "sha256-lGHWE8T4OgojOp9wBq1tFed514nEm9NePMCNfiiG/Ko=";
  };
}
