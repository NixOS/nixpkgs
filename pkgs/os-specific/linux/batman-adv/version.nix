{
  version = "2025.4";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2025.4/$tool-2025.4.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-g3VHVHjtHNQTnJAAF1p9FAfujdkZoLfJ2/fRUJWIBIU=";
    batctl = "sha256-Vmqk/XQ1Xo1d0r0hwl6YzAaOd/0I4Z+AuOK17d58jmU=";
    batman-adv = "sha256-YkkKj4tYwC6Bkhbz6WMkmYRkXT5GAVagQ7c/xT4k+G0=";
  };
}
