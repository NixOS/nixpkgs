{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "datree";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    rev = version;
    hash = "sha256-vixfKipsWVPz12J93t90DDNA8rBfCIDgNRgeKq67ok4=";
  };

  vendorSha256 = "sha256-nUu2xMFi1y6kkB076Bm+ZwFWh5ccyYy+wCP585zWGRw=";

  ldflags = [
    "-extldflags '-static'"
    "-s"
    "-w"
    "-X github.com/datreeio/datree/cmd.CliVersion=${version}"
  ];

  doCheck = true;

  meta = with lib; {
    description =
      "CLI tool to ensure K8s manifests and Helm charts follow best practices as well as your organization’s policies";
    homepage = "https://datree.io/";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.jceb ];
  };
}
