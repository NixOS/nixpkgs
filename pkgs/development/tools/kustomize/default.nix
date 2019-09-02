{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize";
  version = "3.1.0";
  # rev is the 3.1.0 commit, mainly for kustomize version command output
  rev = "95f3303493fdea243ae83b767978092396169baf";

  goPackagePath = "sigs.k8s.io/kustomize";
  subPackages = [ "cmd/kustomize" ];

  buildFlagsArray = let t = "${goPackagePath}/v3/pkg/commands/misc"; in ''
    -ldflags=
      -s -X ${t}.kustomizeVersion=${version}
         -X ${t}.gitCommit=${rev}
         -X ${t}.buildDate=unknown
  '';

  src = fetchFromGitHub {
    sha256 = "0kigcirkjvnj3xi1p28p9yp3s0lff24q5qcvf8ahjwvpbwka14sh";
    rev = "v${version}";
    repo = pname;
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
