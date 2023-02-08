{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-KgCF44kpr8dAHzLgoRKXfd9warQUiFggGZ/Dy/49j1Q=";
  };
  vendorHash = "sha256-d76aeiSkW0sZeFylWIkCoquWzX78s2iaDeX3VE8cYfI=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
