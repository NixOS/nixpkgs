{
  version = "2024.2";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do
  #   nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2024.2/$tool-2024.2.tar.gz --type sha256 | xargs nix hash to-sri --type sha256
  # done
  # ```
  sha256 = {
    alfred = "sha256-Kpvr62fIh1n+31fRjm79qtDECPIGikYlIBfCJ8sQlnI=";
    batctl = "sha256-ywKVMJP/wscA0SLAOj2eTYZ/ZG0wOPMdCpAeWP+ZXQc=";
    batman-adv = "sha256-dpKm3uei8/ZnMumuyMcWTgwYGBZ/OvBjv/P/+7AZlkM=";
  };
}
