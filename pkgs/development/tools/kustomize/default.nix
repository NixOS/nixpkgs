{ lib, stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kustomize-${version}";
  version = "2.0.3";
  # rev is the 2.0.3 commit, mainly for kustomize version command output
  rev = "a6f65144121d1955266b0cd836ce954c04122dc8";

  goPackagePath = "sigs.k8s.io/kustomize";

  buildFlagsArray = let t = "${goPackagePath}/pkg/commands/misc"; in ''
    -ldflags=
      -s -X ${t}.kustomizeVersion=${version}
         -X ${t}.gitCommit=${rev}
         -X ${t}.buildDate=unknown
  '';

  src = fetchFromGitHub {
    sha256 = "1dfkpx9rllj1bzm5f52bx404kdds3zx1h38yqri9ha3p3pcb1bbb";
    rev = "v${version}";
    repo = "kustomize";
    owner = "kubernetes-sigs";
  };

  meta = with lib; {
    description = "Customization of kubernetes YAML configurations";
    longDescription = ''
      kustomize lets you customize raw, template-free YAML files for
      multiple purposes, leaving the original YAML untouched and usable
      as is.
    '';
    homepage = https://github.com/kubernetes-sigs/kustomize;
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos vdemeester periklis zaninime ];
  };
}
