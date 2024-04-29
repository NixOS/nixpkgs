{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnquery";
  version = "11.1.1";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    rev = "refs/tags/v${version}";
    hash = "sha256-99bkEoAfNfejO/M1V8KmAmyP+klrCtmkf1l6aZynEgQ=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-Nb2KSTS85//GC4ikYgrNNoKYJYBYvG9q5GF5RPemklE=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Cloud-native, graph-based asset inventory";
    longDescription = ''
      cnquery is a cloud-native tool for querying your entire fleet. It answers thousands of
      questions about your infrastructure and integrates with over 300 resources across cloud
      accounts, Kubernetes, containers, services, VMs, APIs, and more.
    '';
    homepage = "https://mondoo.com/cnquery";
    changelog = "https://github.com/mondoohq/cnquery/releases/tag/v${version}";
    license = licenses.bsl11;
    maintainers = with maintainers; [ mariuskimmina ];
  };
}
