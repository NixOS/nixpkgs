{
  version = "2023.3";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do
  #   nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2023.3/$tool-2023.3.tar.gz --type sha256 | xargs nix hash to-sri --type sha256
  # done
  # ```
  sha256 = {
    alfred = "sha256-rVrUFJ+uz351MCpXeqpnOxz8lAXSAksrSpFjuscMjk8=";
    batctl = "sha256-mswxFwkwwXl8OHY7h73/iAVMNNHwEvu4EAaCc/7zEhI=";
    batman-adv = "sha256-98bFPlk0PBYmQsubRPEBZ2XUv1E+A5ACvmEremweo2w=";
  };
}
