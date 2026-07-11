{
  version = "2026.2";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2026.2/$tool-2026.2.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-2ZV0i+X2KkIJFSXMwQLfWsZCGG6bkBRpipVaRGm2m5Y=";
    batctl = "sha256-wdWAr7Bm0xZcI5tnQwuUxpkyYZwGqQsSlegoy1CBsSI=";
    batman-adv = "sha256-Thf87SyAlF4iYJvodTRIFzP/G10XBQ3k5PMjwXFBgTU=";
  };
}
