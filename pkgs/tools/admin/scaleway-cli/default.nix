{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "scaleway-cli";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "yYzcziEKPSiMvw9LWd60MkHmYFAvN7Qza6Z117NOOv0=";
  };

  vendorSha256 = "0V9sHi/E095txnfF8YFW5O7o0e1H3sdn3tw5LqB92tI=";

  # some tests require network access to scaleway's API, failing when sandboxed
  doCheck = false;

  meta = with lib; {
    description = "Interact with Scaleway API from the command line";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
  };
}
