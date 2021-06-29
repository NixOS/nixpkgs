{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P16CS1W42Q/glsB9G0kagB5oSgwLb5cGMvKFc9jzd8s=";
  };

  vendorSha256 = "sha256-22T7C4/ph3z+O1c9uC1p2xzg0JFV+TEdfy4iiIS4Y40=";

  # tests want to download a vulnerable Terraform project
  doCheck = false;

  meta = with lib; {
    description = "Detect compliance and security violations across Infrastructure";
    longDescription = ''
      Detect compliance and security violations across Infrastructure as Code to
      mitigate risk before provisioning cloud native infrastructure. It contains
      500+ polices and support for Terraform and Kubernetes.
    '';
    homepage = "https://github.com/accurics/terrascan";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
