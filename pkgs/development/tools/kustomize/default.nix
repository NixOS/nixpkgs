{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize";
  version = "3.8.2";
  # rev is the 3.8.2 commit, mainly for kustomize version command output
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
    sha256 = "1hnp807xbk0s2q8vfjsz9bja17yjyxfmhzpisinsav1m9a51c76k";
  };

  # avoid finding test and development commands
  sourceRoot = "source/kustomize";

  vendorSha256 = "1s8nw3vd3bcn9fnxykkq2bpgliz1lpa1s9h69d8kpndbfv193pjh";

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
