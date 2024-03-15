{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "aws-env";
  version = "0.5";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "Droplr";
    repo = pname;
    inherit rev;
    hash = "sha256-dzXgQW5noWT7u276tlwhvgvu2J8VYrOdW9vidZ3W3t0=";
  };

  vendorHash = "sha256-mZanveQJveLeAymlEloBYYnvBmnlBac0jXX1J55BrEg=";

  preBuild = ''
    cp ${./go.mod} go.mod
    cp ${./go.sum} go.sum
  '';


  ldflags = [ "-s" "-w" ];


  meta = with lib; {
    description = "Secure way to handle environment variables in Docker and envfile with AWS Parameter Store";
    homepage = "https://github.com/Droplr/aws-env";
    license = licenses.mit;
    maintainers = with maintainers; [ srhb ];
    mainProgram = "aws-env";
  };
}
