{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "shiori";
  version = "1.5.5";

  vendorHash = "sha256-suWdtqf5IZntEVD+NHGD6RsL1tjcGH9vh5skISW+aCc=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kGPvCYvLLixEH9qih/F3StUyGPqlKukTWLSw41+Mq8E=";
  };

  passthru.tests = {
    smoke-test = nixosTests.shiori;
  };

  meta = with lib; {
    description = "Simple bookmark manager built with Go";
    mainProgram = "shiori";
    homepage = "https://github.com/go-shiori/shiori";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
