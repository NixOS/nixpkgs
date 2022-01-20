{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-tpJkEq3TuEiJ4bChlWXi2241WMcZjChEt1hV1G+h8f8=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-MEL3VRHPSf1Im09Hw+GX+3J3UGt7j29V4kxzoiWhqfk=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 SuperSandro2000 zimbatm ];
  };
}
