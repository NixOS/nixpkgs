{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize";
  version = "3.8.0";
  # rev is the 3.8.0 commit, mainly for kustomize version command output
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
    sha256 = "1v86gqn16xh28gi2fa6jgbbk0clrcng3sbr1az42iy4mm4nmsriy";
  };

  # avoid finding test and development commands
  sourceRoot = "source/kustomize";

  deleteVendor = true;
  vendorSha256 = "03z40gi9nrj120cd57pa3fmi8grldyxa65a1lkvlc2r3z9g29vdw";

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
