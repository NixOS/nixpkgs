{ lib, buildGoModule, fetchFromGitHub, testers, kubeswitch }:

buildGoModule rec {
  pname = "kubeswitch";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "danielfoehrKn";
    repo = pname;
    rev = version;
    sha256 = "sha256-zf7o41YYAppRge0EMXgIN8rI5Kco4/n7BJ90b/X6L1M=";
  };

  vendorHash = null;

  subPackages = [ "cmd/main.go" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/danielfoehrkn/kubeswitch/cmd/switcher.version=${version}"
    "-X github.com/danielfoehrkn/kubeswitch/cmd/switcher.buildDate=1970-01-01"

  ];

  passthru.tests.version = testers.testVersion {
    package = kubeswitch;
  };

  postInstall = ''
    mv $out/bin/main $out/bin/switch
  '';

  meta = with lib; {
    description = "The kubectx for operators";
    license = licenses.asl20;
    homepage = "https://github.com/danielfoehrKn/kubeswitch";
    maintainers = with maintainers; [ bryanasdev000 ];
    mainProgram = "switch";
  };
}
