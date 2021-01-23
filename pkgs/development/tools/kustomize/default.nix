{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize";
  version = "3.9.2";
  # rev is the 3.9.2 commit, mainly for kustomize version command output
  rev = "e98eada7365fc564c9aba392e954f306a9cbf1dd";

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
    sha256 = "0p1rxswfaj0g3y8nfw70qmxrlyv1pnzkapy1mxpzzyf04mmhg7wn";
  };

  # avoid finding test and development commands
  sourceRoot = "source/kustomize";

  vendorSha256 = "1pv8g0nnrpzbvd6dqgnrw2i27xkilbrr9npdz6pxr7mmbcg3w3w9";

  meta = with lib; {
    description = "Customization of kubernetes YAML configurations";
    longDescription = ''
      kustomize lets you customize raw, template-free YAML files for
      multiple purposes, leaving the original YAML untouched and usable
      as is.
    '';
    homepage = "https://github.com/kubernetes-sigs/kustomize";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos vdemeester periklis zaninime Chili-Man];
  };
}
