{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-Z/J1L6fYuim6LkVh+LDrr3FLTZO7uQwHXRg0YTofkWA=";
  };
  vendorSha256 = "sha256-r/1huS/6qqS6TuqPQkwqKuYwye5DYQWYfBS1IcXWRgk=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
