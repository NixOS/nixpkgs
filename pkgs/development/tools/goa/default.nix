{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.14.6";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-u26k4jKT68AMb9pQf/5FCuX+yGpcuGJ6uOIqXfWbg2o=";
  };
  vendorHash = "sha256-PcPYsTjWt4N27ahHCdx+ZylujmuX/hopN9o7vKUAA5w=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
