{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cilium";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "cilium";
    rev = "v${version}";
    hash = "sha256-LJCWhiPZL0thaIyRsVcJW8AE0/o4aqS2SJSbMNhm1mE=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  excludedPackages = [
    #Makes the build fail because it excpects specific kernel parameters
    "probes"
    #Failes because it's unable to start gops: mkdir /homeless-shelter: permission denied
    "test"
  ];


  meta = with lib; {
    description = "open source, cloud native solution for providing, securing, and observing network connectivity between workloads, EBPF-based Networking, Security, and Observability";
    homepage = "https://cilium.io/";
    changelog = "https://github.com/cilium/cilium/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ janik ];
  };
}
