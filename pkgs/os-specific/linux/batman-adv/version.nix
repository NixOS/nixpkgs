{
  version = "2025.3";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2025.3/$tool-2025.3.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-+wTI22Y6bh0dyeRnEvyr6Ctz0MC0fkC00WEAAu9RCXU=";
    batctl = "sha256-cERLGCyF0MJxTZFFdBJJgIAbt0PRYm7iehefoiBm/cI=";
    batman-adv = "sha256-vggjoJNr9Z4q8tEVp+JjF/giC5mPSDMldGWvK2/+HOg=";
  };
}
