{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j6a956cbmsc9fy500sl5z6l7q5sc4fna772v5m10w0hq0vw6sk5";
  };

  vendorSha256 = "1x7gxjl98i36vsch6b3w6iqyq6q8mj4x9gylk2fihq50c3qq4mk4";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
