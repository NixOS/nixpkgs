{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tfk8s";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jrhouston";
    repo = "tfk8s";
    rev = version;
    sha256 = "sha256-JzTWbkICOIfsHgMvpXz4bIWaXKKDAD8INSorMvnXiBw=";
  };

  vendorSha256 = "sha256-r0c3y+nRc/hCTAT31DasQjxZN86BT8jnJmsLM7Ugrq4=";
  runVend = true;

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X main.toolVersion=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  meta = with lib; {
    description = "An utility to convert Kubernetes YAML manifests to Terraform's HCL format.";
    license = licenses.mit;
    longDescription = ''
      tfk8s is a tool that makes it easier to work with the Terraform Kubernetes Provider.
      If you want to copy examples from the Kubernetes documentation or migrate existing YAML manifests and use them with Terraform without having to convert YAML to HCL by hand, this tool is for you.
      Features:
      * Convert a YAML file containing multiple manifests.
      * Strip out server side fields when piping kubectl get $R -o yaml | tfk8s --strip
    '';
    homepage = "https://github.com/jrhouston/tfk8s/";
    maintainers = with maintainers; [ superherointj ];
  };
}
