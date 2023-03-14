{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "tfplugindocs";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-plugin-docs";
    rev = "v${version}";
    sha256 = "sha256-adOaX8VxMytnALkuXBlmRKfRmk6x7bHTg/oEJQiJ1+U=";
  };

  vendorHash = "sha256-Qo8L0Rm7ZxcZ9YZTqfx51Tt8DRj4M+be6NdrsrwRt30=";

  meta = with lib; {
    description = "Generate and validate Terraform plugin/provider documentation";
    homepage = "https://github.com/hashicorp/terraform-plugin-docs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ lewo ];
  };
}
