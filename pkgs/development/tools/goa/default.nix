{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-iGp3Nkew1Xrvq9Hvhu645e4oguZaHxCXi+mJkdS1mp8=";
  };
  vendorHash = "sha256-QtMBJk0T8+ExX5S/DvltHQfxET5bo563pJoalBx4SAs=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
