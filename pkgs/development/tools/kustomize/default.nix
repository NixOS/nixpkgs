{ lib, buildGoModule, fetchgit, git }:

buildGoModule rec {
  pname = "kustomize";
  version = "3.1.0";

  goPackagePath = "sigs.k8s.io/kustomize";
  subPackages = [ "cmd/kustomize" ];

  src = fetchgit {
    url = "https://github.com/kubernetes-sigs/${pname}";
    rev = "v${version}";
    sha256 = "0z9qg9c1s9g7hjb6gd0ci1mr3rmk3462b7w7dgnyf5fvmhav80d1";
    leaveDotGit = true;
  };

  preBuild = let t = "${goPackagePath}/v3/pkg/commands/misc"; in ''
    export GIT_REVISION=$(git -C $src rev-parse HEAD)
    export buildFlagsArray+=(
      "-ldflags=
        -s -X ${t}.kustomizeVersion=${version}
           -X ${t}.gitCommit=$GIT_REVISION
           -X ${t}.buildDate=1970-01-01T00:00:00Z")
  '';

  buildInputs = [ git ];

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
