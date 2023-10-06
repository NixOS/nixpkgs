{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, testers
, scip
}:

buildGoModule rec {
  pname = "scip";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip";
    rev = "v${version}";
    hash = "sha256-tcnBv+dxuLD/ixeOLGrHu2UVfOnrfANjyaRzW5oDC94=";
  };

  vendorHash = "sha256-+IR3fc6tvSwPGDZ4DxrE48Ii3azcT0LMmID1LRAu5g8=";

  patches = [
    # update documentation to fix broken test
    # https://github.com/sourcegraph/scip/pull/174
    (fetchpatch {
      name = "test-fix-out-of-sync-documentation.patch";
      url = "https://github.com/sourcegraph/scip/commit/7450b7701637956d4ae6669338c808234f7a7bfa.patch";
      hash = "sha256-Y5nAVHyy430xdN89ohA8XAssNdSSPq4y7QaesN48jVs=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Reproducible=true"
  ];

  postInstall = ''
    mv $out/bin/{cmd,scip}
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = scip;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "SCIP Code Intelligence Protocol CLI";
    homepage = "https://github.com/sourcegraph/scip";
    changelog = "https://github.com/sourcegraph/scip/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
