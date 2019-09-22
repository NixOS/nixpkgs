{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lhg81bsmzxs46329rlayf8k2y7fbjlmxj09rqbygr9f0693rzgy";
  };

  modSha256 = "10za02363yglhj0pbsd2591rflrrcq12gxx9d53pg9hb7lrxj9ij";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
