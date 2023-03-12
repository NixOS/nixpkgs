{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.1.181";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C6qZdO6+n9BWm69y09kvnEBF45sB6bfOfmteNO2x68I=";
  };

  vendorHash = "sha256-cySflcTuAzbFZbtXmzZ98nfY8HUq1UedONTtKP4EICs=";

  meta = with lib; {
    homepage = "https://xcfile.dev/";
    description = "Markdown defined task runner";
    license = licenses.mit;
    maintainers = with maintainers; [ joerdav ];
  };
}
