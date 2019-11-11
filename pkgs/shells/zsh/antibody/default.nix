{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "antibody";
  version = "4.2.0";

  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    rev = "v${version}";
    sha256 = "1vds7mxqxa7xlhvjvmnh1nr1ra3dciav0qlv45s1dmwn5qrcilci";
  };

  modSha256 = "1n9sgrm16iig600f4q1cmbwwk0822isjvbyazplylha843510b17";

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = https://github.com/getantibody/antibody;
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 worldofpeace ];
  };
}
