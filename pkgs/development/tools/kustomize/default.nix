{ lib, stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kustomize-${version}";
  version = "2.0.1";
  # rev is the 2.0.1 commit, mainly for kustomize version command output
  rev = "ce7e5ee2c30cc5856fea01fe423cf167f2a2d0c3";

  goPackagePath = "sigs.k8s.io/kustomize";

  buildFlagsArray = let t = "${goPackagePath}/pkg/commands/misc"; in ''
    -ldflags=
      -s -X ${t}.kustomizeVersion=${version}
         -X ${t}.gitCommit=${rev}
         -X ${t}.buildDate=unknown
  '';

  src = fetchFromGitHub {
    sha256 = "1ljllx2gd329lnq6mdsgh8zzr517ji80b0j21pgr23y0xmd43ijf";
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
