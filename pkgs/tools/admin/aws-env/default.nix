{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "aws-env";
  version = "0.5";
  rev = "v${version}";

  goPackagePath = "github.com/Droplr/aws-env";

  src = fetchFromGitHub {
    owner = "Droplr";
    repo = pname;
    inherit rev;
    sha256 = "sha256-dzXgQW5noWT7u276tlwhvgvu2J8VYrOdW9vidZ3W3t0=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Secure way to handle environment variables in Docker and envfile with AWS Parameter Store";
    homepage = "https://github.com/Droplr/aws-env";
    license = licenses.mit;
    maintainers = with maintainers; [ srhb ];
    mainProgram = "aws-env";
  };
}
