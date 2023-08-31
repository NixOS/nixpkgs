{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.12.4";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-ox4UPwotJBA8qxZpqyKmOW2bqbSWHX+yIpGvFnf2Rzo=";
  };
  vendorHash = "sha256-AIhAMgpVLMxeYoj4Jl4O92/etOtFD++ddV18R8aYRuY=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
