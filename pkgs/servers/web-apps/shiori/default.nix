{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "shiori";
  version = "1.5.2";

  vendorSha256 = "sha256-6XF4wBwoRnINAskhGHTw4eAJ9zAaoZcEYo9/xZk4ems=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Py6Lq29F7RkvSui+Z2VyogU9+azHQ2KEvEq924pQmQo=";
  };

  passthru.tests = {
    smoke-test = nixosTests.shiori;
  };

  meta = with lib; {
    description = "Simple bookmark manager built with Go";
    homepage = "https://github.com/go-shiori/shiori";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
