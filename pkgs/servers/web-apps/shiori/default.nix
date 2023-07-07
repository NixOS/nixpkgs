{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "shiori";
  version = "1.5.4";

  vendorHash = "sha256-8aiaG2ry/XXsosbrLBmwnjbwIhbKMdM6WHae07MG7WI=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QZTYhRz65VLs3Ytv0k8ptfeQ/36M2VBXFaD9zhQXDh8=";
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
