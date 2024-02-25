{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnquery";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    rev = "v${version}";
    hash = "sha256-bz4a4+mgssrRBthkN87aYxlZV6as2uocFvBKrKLmy8A=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-vq6R2FgvoET8SLTpktGLoFzZHqnmizDp0fWU7kqlLgU=";

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
