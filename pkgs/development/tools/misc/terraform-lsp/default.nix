{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-lsp";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "juliosueiras";
    repo = pname;
    rev = "v${version}";
    sha256 = "018ypvmd9cwys5l7rm1c7b9jf8fljdk0m22id32d88jiw4iwq44m";
  };

  modSha256 = "1196fn69nnplj7sz5mffawf58j9n7h211shv795gknvfnwavh344";

  meta = with lib; {
    description = "Language Server Protocol for Terraform";
    homepage = "https://github.com/juliosueiras/terraform-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
