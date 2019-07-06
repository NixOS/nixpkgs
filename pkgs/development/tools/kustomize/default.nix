{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "kustomize-${version}";
  version = "3.0.0";
  # rev is the 3.0.0 commit, mainly for kustomize version command output
  rev = "e0bac6ad192f33d993f11206e24f6cda1d04c4ec";

  goPackagePath = "sigs.k8s.io/kustomize";
  subPackages = [ "cmd/kustomize" ];

  buildFlagsArray = let t = "${goPackagePath}/pkg/commands/misc"; in ''
    -ldflags=
      -s -X ${t}.kustomizeVersion=${version}
         -X ${t}.gitCommit=${rev}
         -X ${t}.buildDate=unknown
  '';

  src = fetchFromGitHub {
    sha256 = "1ywppn97gfgrwlq1nrj4kdvrdanq5ahqaa636ynyp9yiv9ibziq6";
    rev = "v${version}";
    repo = "kustomize";
    owner = "kubernetes-sigs";
  };

  modSha256 = "0w8sp73pmj2wqrg7x7z8diglyfq6c6gn9mmck0k1gk90nv7s8rf1";

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
