{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "shiori";
  version = "1.5.3";

  vendorSha256 = "sha256-vyBb8jNpXgpiktbn2lphL2wAeKmvjJLxV8ZrHoUSNYY=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-razBb/flqwyFG4SPWhSapDO1sB5DYzyjYGx8ABFg/I8=";
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
