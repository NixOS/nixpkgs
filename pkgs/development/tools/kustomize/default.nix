{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize";
  version = "3.8.7";
  # rev is the 3.8.7 commit, mainly for kustomize version command output
  rev = "ad092cc7a91c07fdf63a2e4b7f13fa588a39af4f";

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
    sha256 = "1942cyaj6knf8mc3q2vcz6rqqc6lxdd6nikry9m0idk5l1b09x1m";
  };

  # avoid finding test and development commands
  sourceRoot = "source/kustomize";

  vendorSha256 = "0y77ykfcbn4l0x85c3hb1lgjpy64kimx3s1qkn38gpmi4lphvkkl";

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
