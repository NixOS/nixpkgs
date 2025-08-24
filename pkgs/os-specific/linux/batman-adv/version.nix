{
  version = "2025.2";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2025.2/$tool-2025.2.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-Q0fR5LB5Svv2sXGoV7mjx9UaKR/FTxbNrZLH99HNtRo=";
    batctl = "sha256-q2wDRqFvER57n9XOVczd633grXdCvi9FExfrQo9qCpY=";
    batman-adv = "sha256-FsRfi7jzBTcc2Q6IhjDPslHCsYnlUypSepNvo1ukl/c=";
  };
}
