{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-cVCzuOZf2zFY01+t20sRArEFinWqvZ461jJIQIyf0yI=";
  };
  vendorSha256 = "sha256-xLn7qGmBtNSnIZ7Gn4h/Aa037V0lO1jT/8P9PB7bH5o=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
