{
  version = "2026.0";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2026.0/$tool-2026.0.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-35EVL+Mftjd6JM6TEwRFlzUQRpr5N35MycX10l4451E=";
    batctl = "sha256-tLcNrmIBBuRe492x9RL2kHVpKxI0PQUhJnQDyyEqSiY=";
    batman-adv = "sha256-lGHWE8T4OgojOp9wBq1tFed514nEm9NePMCNfiiG/Ko=";
  };
}
