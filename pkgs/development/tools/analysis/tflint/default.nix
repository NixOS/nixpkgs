{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nj36xxl8zg7wdc36lakzdyr9hk82qwkwrvrw19bqach697y57nf";
  };

  vendorSha256 = "0bzd58ry5k100mjgvl1mxz7aysm75s4vkilcykrqy1s5sc0h3ng5";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
