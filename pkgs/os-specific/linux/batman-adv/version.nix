{
  version = "2024.3";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do
  #   nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2024.3/$tool-2024.3.tar.gz --type sha256 | xargs nix hash to-sri --type sha256
  # done
  # ```
  sha256 = {
    alfred = "sha256-1xFDOMGgZGla9x1Y3gNnenIZsHxVQpuA+G3APAJJ/+o=";
    batctl = "sha256-Zl5lXto4FBUhik1fX9d/8zxPqbXtu36I6DkJaWHjYAs=";
    batman-adv = "sha256-uWgX7R9PSJF8MlUKhPqtjIfs9Tqm9vRswmVUuZm1f/M=";
  };
}
