{
  version = "2025.1";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2025.1/$tool-2025.1.tar.gz --type sha256 | xargs nix hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-f7iz8cxOxIjo1D/ZFd2gp831thG/OdYN3rRIasACXxg=";
    batctl = "sha256-IPii4TWgeKrBblyK1TWhKhVc8Lea8YPeX7F9qVe8JHg=";
    batman-adv = "sha256-A61CkpeWH7Os2cLIBkMtA3sO16rA8KHmReMq9SELmOE=";
  };
}
