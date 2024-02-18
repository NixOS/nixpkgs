{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-F5ynJn3uuKSNZYZy+S6OV0AGv9HMpp4oo7lacQ+q3bw=";
  };
  vendorHash = "sha256-SvNuSSLL/zj7rg+k0wNiJazQgZBWrUrpGgumbADkHQY=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
