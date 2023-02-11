{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "tfplugindocs";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-plugin-docs";
    rev = "v${version}";
    sha256 = "sha256-0FpzUJDFGKLe88QW+7UI6QPwFMUfqPindOHtGRpOLo8=";
  };

  vendorSha256 = "sha256-gKRgFfyUahWI+c97uYSCAGNoFy2RPgAw0uYGauEOLt8=";

  meta = with lib; {
    description = "Generate and validate Terraform plugin/provider documentation";
    homepage = "https://github.com/hashicorp/terraform-plugin-docs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ lewo ];
  };
}
