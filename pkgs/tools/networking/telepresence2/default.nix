{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "telepresence2";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = "v${version}";
    sha256 = "1bs4h450109vhy18kpyy6y4p5l9kvz4w09m56fxh5z547m5ax6k3";
  };

  vendorSha256 = "0xmw9mc0iy64kb12lsii4nn63ynh6gab9ls8z6mrizjjqz845sa5";

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
