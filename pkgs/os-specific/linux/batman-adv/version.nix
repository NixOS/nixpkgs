{
  version = "2024.0";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do
  #   nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2024.0/$tool-2024.0.tar.gz --type sha256 | xargs nix hash to-sri --type sha256
  # done
  # ```
  sha256 = {
    alfred = "sha256-0CmkNjirFnceX3HhNLyEPRcT10BBxlvNoYox0Y9VMb0=";
    batctl = "sha256-doU+hyAa9jxBHbFS/QxiWnKalzMRWJfRMxYE4sWmfH0=";
    batman-adv = "sha256-YREGl7V5n2RqKoKk3Pl/rtS7EqfMQ79Gg9LE3k9rQOc=";
  };
}
