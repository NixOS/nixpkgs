{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize";
  version = "3.10.0";
  # rev is the 3.9.3 commit, mainly for kustomize version command output
  rev = "602ad8aa98e2e17f6c9119e027a09757e63c8bec";

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
    sha256 = "1qr0mi83df8d9qd2svyr1h26pg97qi67nnygrkydnp8an28k48hi";
  };

  # avoid finding test and development commands
  sourceRoot = "source/kustomize";

  vendorSha256 = "0p2j8mm7jpladpm6v3451g38n5bax0g368dk5h5r5gmkr6srxdy4";

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
