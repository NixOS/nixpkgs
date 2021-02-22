{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xln0a5n8na3p6b7l8im3bh4ys5rr3k413ibzk8mnp471f5h1558";
  };

  vendorSha256 = "05qdwz1icl8in0j94gx9pgplidm2v29hsn4kgg5gw35bsbn1c7id";

  doCheck = false;

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
