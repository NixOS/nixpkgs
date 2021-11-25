{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize";
  version = "4.4.0";
  # rev is the commit of the tag, mainly for kustomize version command output
  rev = "9e8e7a7fe99ec9fbf801463e8607928322fc5245";

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
    sha256 = "sha256-dHCUuKEUJ4xKMfeR629y/cdM7ZBgP3GxUSKGQYj9Ahg=";
  };

  # TODO: Remove once https://github.com/kubernetes-sigs/kustomize/pull/3708 got merged.
  doCheck = false;

  # avoid finding test and development commands
  sourceRoot = "source/kustomize";

  vendorSha256 = "sha256-jP3Jf8QtdNnCrXO3JfyQNCfMwz9d3UaKVTh8DSbx6vA=";

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
