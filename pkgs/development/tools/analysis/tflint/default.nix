{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p6859lax6cmk2q4pvqw4sm78k80gs2561nxa1gwdna3af211fbp";
  };

  modSha256 = "021iqy5a703cymcc66rd1rxnpqa3rnzj37y400s0rmiq0zpkm2nc";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
