{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dma1nav6z9919lj4f7cqcf8h12l4gbwn24323y18l57zv988331";
  };

  modSha256 = "1xjxaszpxv9k9s27y1i54cnp0ip47bq4ad2ziq7n8nb76zxw03mx";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
