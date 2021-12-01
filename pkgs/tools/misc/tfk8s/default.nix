{ lib, buildGoModule, fetchFromGitHub, callPackage }:

buildGoModule rec {
  pname = "tfk8s";
  version = "0.1.7";
  tag = "v${version}";

  src = fetchFromGitHub {
    owner = "jrhouston";
    repo = "tfk8s";
    rev = tag;
    sha256 = "0mkfggwjrsp0rzh7ll6nmp9kqcw4fl8q81vk67z5mbd276dkyxrb";
  };

  vendorSha256 = "sha256-eLPmghs05pMMtys97Ja7YGdVMZmMmiaFeMwzaWNxW0I=";
  runVend = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.toolVersion=${tag}"
    "-X main.builtBy=nixpkgs"
  ];

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/tfk8s --version | grep ${tag} > /dev/null
  '';

  passthru.tests = {
    sample1 = callPackage ./tests/sample1 { };
  };

  meta = with lib; {
    description = "An utility to convert Kubernetes YAML manifests to Terraform's HCL format";
    license = licenses.mit;
    longDescription = ''
      tfk8s is a tool that makes it easier to work with the Terraform Kubernetes Provider.
      If you want to copy examples from the Kubernetes documentation or migrate existing YAML manifests and use them with Terraform without having to convert YAML to HCL by hand, this tool is for you.
      Features:
      * Convert a YAML file containing multiple manifests.
      * Strip out server side fields when piping kubectl get $R -o yaml | tfk8s --strip
    '';
    homepage = "https://github.com/jrhouston/tfk8s/";
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
