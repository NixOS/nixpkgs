{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize";
  version = "3.8.1";
  # rev is the 3.8.1 commit, mainly for kustomize version command output
  rev = "6a50372dd5686df22750b0c729adaf369fbf193c";

  buildFlagsArray = let t = "sigs.k8s.io/kustomize/api/provenance"; in
    ''
      -ldflags=
        -s -X ${t}.version=${version}
           -X ${t}.gitCommit=${rev}
    '';

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "kustomize/v${version}";
    sha256 = "07zdp6xv8viwnaz1qacwhg82dlzcrgb8dls6yz9qk4qcnsk6badx";
  };

  # avoid finding test and development commands
  sourceRoot = "source/kustomize";

  deleteVendor = true;
  vendorSha256 = "01ff3w4hwp4ynqhg8cplv0i2ixs811d2x2j6xbh1lslyyh3z3wc5";

  meta = with lib; {
    description = "Customization of kubernetes YAML configurations";
    longDescription = ''
      kustomize lets you customize raw, template-free YAML files for
      multiple purposes, leaving the original YAML untouched and usable
      as is.
    '';
    homepage = "https://github.com/kubernetes-sigs/kustomize";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos vdemeester periklis zaninime ];
  };
}
