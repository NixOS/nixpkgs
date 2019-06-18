{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kqlwncsxssi1jchmrg1wmv7dknp0shx33j7kkryy12wdxxcbwyb";
  };

  modSha256 = "1j5hjr4l4ivvhrywk286zczsn9balaaq5l5qx4ga4v0llwspmygm";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
