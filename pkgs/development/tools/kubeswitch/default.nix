{ lib, buildGoModule, fetchFromGitHub, testers, kubeswitch }:

buildGoModule rec {
  pname = "kubeswitch";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "danielfoehrKn";
    repo = pname;
    rev = version;
    sha256 = "sha256-p4/nYZt+OwNsFX9f9ySfQaz6gbz+8Mvt00W2Rs4dpCY=";
  };

  vendorSha256 = null;

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
