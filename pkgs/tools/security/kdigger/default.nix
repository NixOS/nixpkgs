{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, fetchpatch
}:

buildGoModule rec {
  pname = "kdigger";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "quarkslab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-j4HIwfRIUpV25DmbQ+9go8aJMEYaFDPxrdr/zGWBeVU=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorSha256 = "sha256-3vn3MsE/4lBw89wgYgzm0RuJJ5RQTkgS6O74PpfFcUk=";

  patches = [
    (fetchpatch {
      name = "simplify-ldflags.patch";
      url = "https://github.com/quarkslab/kdigger/pull/2.patch";
      sha256 = "sha256-d/NdoAdnheVgdqr2EF2rNn3gJvbjRZtOKFw2DqWR8TY=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X github.com/quarkslab/kdigger/commands.VERSION=v${version}"
    "-X github.com/quarkslab/kdigger/commands.BUILDERARCH=${stdenv.hostPlatform.linuxArch}"
  ];

  preBuild = ''
    ldflags+=" -X github.com/quarkslab/kdigger/commands.GITCOMMIT=$(cat COMMIT)"
  '';

  postInstall = ''
    installShellCompletion --cmd kdigger \
      --bash <($out/bin/kdigger completion bash) \
      --fish <($out/bin/kdigger completion fish) \
      --zsh <($out/bin/kdigger completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/kdigger --help

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/quarkslab/kdigger";
    changelog = "https://github.com/quarkslab/kdigger/releases/tag/v${version}";
    description = "An in-pod context discovery tool for Kubernetes penetration testing";
    longDescription = ''
      kdigger, short for "Kubernetes digger", is a context discovery tool for
      Kubernetes penetration testing. This tool is a compilation of various
      plugins called buckets to facilitate pentesting Kubernetes from inside a
      pod.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    # aarch64-linux support progress - https://github.com/quarkslab/kdigger/issues/3
    platforms = [ "x86_64-linux" ];
  };
}
