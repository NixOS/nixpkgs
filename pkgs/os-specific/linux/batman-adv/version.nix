{
  version = "2024.4";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do
  #   nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2024.4/$tool-2024.4.tar.gz --type sha256 | xargs nix hash to-sri --type sha256
  # done
  # ```
  sha256 = {
    alfred = "sha256-06WtkGtygDbkc1+dZKcrlzHxb4Hz2N9Ay0eFkaO9IpQ=";
    batctl = "sha256-5CvfGk7LSxiLzTrKF+EgSWpCtlR1k7kX4//PlD4/KRM=";
    batman-adv = "sha256-pVTfb8erzMayQ/Vup7GESGyV6phtsRM/h6r+I32pLyE=";
  };
}
