{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gortr";
  version = "0.14.7";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "10dq42d3hb6a3ln3x1rag1lqzhwqb66xn4q8k4igjkn5my81nr6q";
  };

  vendorSha256 = "1nwrzbpqycr4ixk8a90pgaxcwakv5nlfnql6hmcc518qrva198wp";

  meta = with lib; {
    description = "The RPKI-to-Router server used at Cloudflare";
    homepage = "https://github.com/cloudflare/gortr/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
