{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "oneshot";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "raphaelreyna";
    repo = "oneshot";
    rev = "v${version}";
    sha256 = "11xmvqj7md970rjhkg1zj2w6yqpw6cj83aw37a82sfdn90kyhg9d";
  };

  vendorSha256 = "1cxr96yrrmz37r542mc5376jll9lqjqm18k8761h9jqfbzmh9rkp";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A first-come-first-serve single-fire HTTP server";
    homepage = "https://github.com/raphaelreyna/oneshot";
    license = licenses.mit;
    maintainers = with maintainers; [ edibopp ];
  };
}
