{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnquery";
  version = "9.11.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    rev = "v${version}";
    hash = "sha256-3fyX6vz3lqnV07gu/H7qeIrLyNSbqhLpICJWqPTv7T0=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-7zZRX0LWDmO7LA0fIjAh8+5kK2dcAV/4HQmKdn9I3Mg=";

  meta = with lib; {
    description = "cloud-native, graph-based asset inventory";
    longDescription = ''
    cnquery is a cloud-native tool for querying your entire fleet. It answers thousands of questions about your infrastructure and integrates with over 300 resources across cloud accounts, Kubernetes, containers, services, VMs, APIs, and more.
      '';
    homepage = "https://mondoo.com/cnquery";
    changelog = "https://github.com/mondoohq/cnquery/releases/tag/v${version}";
    license = licenses.bsl11;
    maintainers = with maintainers; [ mariuskimmina ];
  };
}
