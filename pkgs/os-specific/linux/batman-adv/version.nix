{
  version = "2024.1";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do
  #   nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2024.1/$tool-2024.1.tar.gz --type sha256 | xargs nix hash to-sri --type sha256
  # done
  # ```
  sha256 = {
    alfred = "sha256-Ji2tOcm+EirH8GFwXIo+O21GJ4K74zcubfyazgw4Tbk=";
    batctl = "sha256-aD3anWBU6yYKGsACLGQnmP9ASNbFOmcuoLMXjmt1egk=";
    batman-adv = "sha256-pxQynGJR9IMOnPA/U8v7IoDwZ4RxtUxdRvrmGngtQyU=";
  };
}
