{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-mbJ9CzJxhAxYByfNpNux/zOWBGaiH4fvIRIh+BMprMk=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-Wx0tXrw3Y3Of3aZNYiD9EVYKFpqA3kqe5tFqppoe0A0=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
  };
}
