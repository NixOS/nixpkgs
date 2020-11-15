{ lib, buildGoModule, fetchFromGitHub, tree }:

buildGoModule rec {
  pname = "kustomize";
  version = "3.3.1";
  # rev is the 3.3.1 commit, mainly for kustomize version command output
  rev = "f2ac5a2d0df13c047fb20cbc12ef1a3b41ce2dad";

  buildFlagsArray = let t = "sigs.k8s.io/kustomize/v3/provenance"; in ''
    -ldflags=
      -s -X ${t}.version=${version}
         -X ${t}.gitCommit=${rev}
         -X ${t}.buildDate=unknown
  '';

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yxxz0b56r18w178y32s619zy8ci6l93c6vlzx11hhxhbw43f6v6";
  };

  # avoid finding test and development commands
  sourceRoot = "source/kustomize";

  vendorSha256 = "06mf5zvxn10g5rqjpqv3afvhj9xmijbj8ag8pqcg1996s4rp4p7a";

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