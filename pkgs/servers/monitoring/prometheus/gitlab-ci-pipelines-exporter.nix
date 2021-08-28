{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    sha256 = "13zs8140n4z56i0xkl6jvvmwy80l07dxyb23wxzd5avbdm8knypz";
  };

  vendorSha256 = "1k620r3d1swhj7cfmqjh5n08da2a6w87fwrsajl0y324iyw2chsa";

  doCheck = true;

  meta = with lib; {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = licenses.asl20;
    maintainers = [ maintainers.mmahut ];
  };
}
