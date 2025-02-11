{
  version = "2025.0";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2025.0/$tool-2025.0.tar.gz --type sha256 | xargs nix hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-x7U5aZp0RuoKGLh9uF/Y+SCiv0mnAqkD+ACitygRI4s=";
    batctl = "sha256-3V9bcd0XUOuo1p3TrfcHiXQcbPY4zyvyzLwvuE9cFo8=";
    batman-adv = "sha256-uQxFRNPPOfbXzZIGEmsWL1EQ+7SYDeltRfvPUDPQhRo=";
  };
}
