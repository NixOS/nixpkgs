{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  name = "mesos-dns-${version}";
  version = "0.1";

  goPackagePath = "github.com/mesosphere/mesos-dns";

  src = fetchFromGitHub {
    owner = "mesosphere";
    repo = "mesos-dns";
    rev = "29940029d4b0c17142373c3280a8b452722b665b";
    sha256 = "1fycywhdyymibsahjqx9vnigk3pdis3hnmfbxp74pmd9xqqlyv1n";
  };

  # Avoid including the benchmarking test helper in the output:
  subPackages = [ "." ];

  buildInputs = with goPackages; [ go dns ];
  dontInstallSrc = true;

  meta = with lib; {
    description = "DNS-based service discovery for Mesos clusters";
    homepage = https://github.com/mesosphere/mesos-dns;
    license = licenses.apsl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
