{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fulcio";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jNsW4eUpqa1a1itEnY1932ta3UpjLxhbHz9byM6/Rxo=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorSha256 = "sha256-L+20HvkRAs00tbD5q1ATeLrKoa7VFQlrXChh7AtK0PI=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sigstore/fulcio/pkg/server.gitVersion=v${version}"
    "-X github.com/sigstore/fulcio/pkg/server.gitTreeState=clean"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X github.com/sigstore/fulcio/pkg/server.gitCommit=$(cat COMMIT)"
    ldflags+=" -X github.com/sigstore/fulcio/pkg/server.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  preCheck = ''
    # test all paths
    unset subPackages

    # skip test that requires networking
    substituteInPlace pkg/config/config_network_test.go \
      --replace "TestLoad" "SkipLoad"
  '';

  postInstall = ''
    installShellCompletion --cmd fulcio \
      --bash <($out/bin/fulcio completion bash) \
      --fish <($out/bin/fulcio completion fish) \
      --zsh <($out/bin/fulcio completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/fulcio --help
    $out/bin/fulcio version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/fulcio";
    changelog = "https://github.com/sigstore/fulcio/releases/tag/v${version}";
    description = "A Root-CA for code signing certs - issuing certificates based on an OIDC email address";
    longDescription = ''
      Fulcio is a free code signing Certificate Authority, built to make
      short-lived certificates available to anyone. Based on an Open ID Connect
      email address, Fulcio signs x509 certificates valid for under 20 minutes.

      Fulcio was designed to run as a centralized, public-good instance backed
      up by other transparency logs. Development is now underway to support
      different delegation models, and to deploy and run Fulcio as a
      disconnected instance.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
