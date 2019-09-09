{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aff7ckl245cyjs2rbgczkqlp2x6g4g458p4li0k1agk3m9bbq35";
  };

  modSha256 = "1facqppgpmmz2j7j77fa3mnjv2nzjxz4ya6xvyvyy92ma0ybclgh";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
