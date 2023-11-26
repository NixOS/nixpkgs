{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fulcio";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LT8J9s008XQtDtNdH1ungQREqQUrlTsoxnlRLKimqLY=";
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
  vendorHash = "sha256-ImZJXdOfMepMFU1z47XyNU39NGGdiCzQji2/tKVfibQ=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X sigs.k8s.io/release-utils/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X sigs.k8s.io/release-utils/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
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
    $out/bin/fulcio version 2>&1 | grep "v${version}"
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
