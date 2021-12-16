{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize";
  version = "4.4.1";
  # rev is the commit of the tag, mainly for kustomize version command output
  rev = "b2d65ddc98e09187a8e38adc27c30bab078c1dbf";

  ldflags = let t = "sigs.k8s.io/kustomize/api/provenance"; in
    [
      "-s"
      "-X ${t}.version=${version}"
      "-X ${t}.gitCommit=${rev}"
    ];

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "kustomize/v${version}";
    sha256 = "sha256-gq5SrI1f6ctGIL0Arf8HQMfgnlglwWlsn1r27Ug70gs=";
  };

  doCheck = true;

  # avoid finding test and development commands
  sourceRoot = "source/kustomize";

  vendorSha256 = "sha256-2GbRk7A8VwGONmL74cc2TA+MLyJrSSOQPLaded5s90k=";

  meta = with lib; {
    description = "Customization of kubernetes YAML configurations";
    longDescription = ''
      kustomize lets you customize raw, template-free YAML files for
      multiple purposes, leaving the original YAML untouched and usable
      as is.
    '';
    homepage = "https://github.com/kubernetes-sigs/kustomize";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos vdemeester periklis zaninime Chili-Man saschagrunert ];
  };
}
