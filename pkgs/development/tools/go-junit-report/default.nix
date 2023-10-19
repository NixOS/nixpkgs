{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-junit-report";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jstemmer";
    repo = "go-junit-report";
    rev = "v${version}";
    sha256 = "sha256-Xz2tJtacsd6PqqA0ZT2eRgTACZonhdDtRWfBGcHW3A4=";
  };

  vendorHash = "sha256-+KmC7m6xdkWTT/8MkGaW9gqkzeZ6LWL0DXbt+12iTHY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Convert go test output to junit xml";
    homepage = "https://github.com/jstemmer/go-junit-report";
    license = licenses.mit;
    maintainers = with maintainers; [ cryptix ];
  };
}
