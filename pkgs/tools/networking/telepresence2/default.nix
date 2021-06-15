{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "telepresence2";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = "v${version}";
    sha256 = "0pr6vm68jr5ld7hy2b4dwmjziir59vg137c74rdn1wlhq3n8vr41";
  };

  vendorSha256 = "0d0p879zchhrzrf6f5zc3vdcd5zi1ind7ibvb46y6wx6lp0f1nrp";

  buildFlagsArray = ''
    -ldflags=-s -w -X=github.com/telepresenceio/telepresence/v2/pkg/version.Version=${src.rev}
  '';

  subPackages = [ "cmd/telepresence" ];

  meta = with lib; {
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    homepage = "https://www.getambassador.io/docs/telepresence/2.1/quick-start/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
