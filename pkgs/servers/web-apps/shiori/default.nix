{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

let
  pname = "shiori";
  version = "1.6.0";
in
buildGoModule {
  inherit pname version;

  vendorHash = "sha256-LLiBRsh9HsadeHQh4Yvops1r2GfjtvQKt5ZelQnPGdI=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Jb73qah5v6fOkapETQ42t0VqbYCEcRy5r7cS6eLVjRM=";
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
