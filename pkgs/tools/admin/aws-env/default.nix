{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "aws-env";
  version = "0.4";
  rev = "v${version}";

  goPackagePath = "github.com/Droplr/aws-env";

  src = fetchFromGitHub {
    owner = "Droplr";
    repo = pname;
    inherit rev;
    sha256 = "0pw1qz1nn0ig90p8d8c1qcwsdz0m9w63ib07carhh86gw55425j7";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Secure way to handle environment variables in Docker and envfile with AWS Parameter Store";
    homepage = "https://github.com/Droplr/aws-env";
    license = licenses.mit;
    maintainers = with maintainers; [ srhb ];
  };
}
