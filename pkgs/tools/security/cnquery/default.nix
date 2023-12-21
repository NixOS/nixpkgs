{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnquery";
  version = "9.12.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    rev = "v${version}";
    hash = "sha256-d2S9qEm0jvXvpU7IHpurDJ7A21bvjuM3HrdRPaujzTU=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-vEJcdGgev9C/3vGx+SMmD9dLMau5Jyx2TjHiiQQ+16A=";

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
