{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.7.0";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "0vylrsmpszij23yngk7mfysp8rjbf29nyskbrwwysf63r9xbrwbi";
  };

  modRoot = "gopls";
  vendorSha256 = "1mnc84nvl7zhl4pzf90cd0gvid9g1jph6hcxk6lrlnfk2j2m75mj";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 zimbatm ];
  };
}
