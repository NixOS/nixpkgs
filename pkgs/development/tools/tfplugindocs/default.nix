{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "tfplugindocs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-plugin-docs";
    rev = "v${version}";
    sha256 = "sha256-1grwbi/nG0d2NwEE/eOeo1+0uGpZ1BRJdubyLwhvKfU=";
  };

  vendorSha256 = "sha256-VhnPRBVlvR/Xh7wkX7qx0m5s+yBOCJQE1zcAe8//lNw=";

  meta = with lib; {
    description = "Generate and validate Terraform plugin/provider documentation";
    homepage = "https://github.com/hashicorp/terraform-plugin-docs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ lewo ];
  };
}
