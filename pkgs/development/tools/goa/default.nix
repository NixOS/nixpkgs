{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.7.6";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-AxMt9XnpUvAwWtjh391ep+MFysF5I/HUeHS8Kq8/fvU=";
  };
  vendorSha256 = "sha256-eTMqvl7h12GbzEmO5Lo4hdFrbqti3zl9edTz+zS0Xu8=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
