{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "quicktemplate";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "valyala";
    repo = "quicktemplate";
    rev = "v${version}";
    sha256 = "mQhrQcKRDtcXha7FIwCIUwWfoPGIJ5YLbA4HdatIdn8=";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://github.com/valyala/quicktemplate";
    description = "Fast, powerful, yet easy to use template engine for Go";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
  };
}
