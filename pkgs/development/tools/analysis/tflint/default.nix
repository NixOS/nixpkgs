{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "12a1jg4vcp6w72j8nsxf162i616g303cs783wlsa9iwm4w0cpb2h";
  };

  modSha256 = "1k26i01sdgx9yik5fnd8kv300d8llqpvj9qpvga7hsbk58s2g8mv";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
