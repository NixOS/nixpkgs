{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  name = "mesos-dns-${version}";
  version = "0.1";

  goPackagePath = "github.com/mesosphere/mesos-dns";

  src = fetchFromGitHub {
    owner = "mesosphere";
    repo = "mesos-dns";
    rev = "f37051fc5a723eb021797e7d57d92755c011a28e";
    sha256 = "0djzd4zdpr4dcp56rqprncan6pcff6gy4wxi9572fmni2ldj4l15";
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
