{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, protobuf
, git
, testers
, buf
, installShellFiles
}:

buildGoModule rec {
  pname = "buf";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KnG1FUdC8xpW/wI4E8+RzO0StKF+N7Wx1jTWNm4302M=";
  };

  vendorSha256 = "sha256-e/hkJoQ1GkSl4mhhgYVB4POult87DzWOXRLGyDVP+M0=";

  patches = [
    # Skip a test that requires networking to be available to work.
    ./skip_test_requiring_network.patch
    # Skip TestWorkspaceGit which requires .git and commits.
    ./skip_test_requiring_dotgit.patch
    # Remove reliance of tests on file protocol which is disabled in git by default now
    # Rebased upstream change https://github.com/bufbuild/buf/commit/bcaa77f8bbb8f6c198154c7c8d53596da4506dab
    ./buf-tests-dont-use-file-transport.patch
    # Make TestCyclicImport tests deterministic (see https://github.com/bufbuild/buf/pull/1551)
    (fetchpatch {
      url = "https://github.com/bufbuild/buf/commit/75b5ef4c84f5953002dff95a1c66cb82b0e3b06f.patch";
      sha256 = "sha256-pKF3VXkzttsTTT2r/Z37ug9nnu8gRdkfmv/aTOhAJpw=";
    })
    # Make TestDuplicateSyntheticOneofs check deterministic (see https://github.com/bufbuild/buf/pull/1579)
    (fetchpatch {
      url = "https://github.com/bufbuild/buf/commit/9e72aa314e6f02b36793caa5f6068394cbdcb98c.patch";
      sha256 = "sha256-6NEF3sP1EQ6cQxkH2xRyHxAD0OrXBlQQa05rLK998wo=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  checkInputs = [
    git # Required for TestGitCloner
    protobuf # Required for buftesting.GetProtocFilePaths
  ];

  preCheck = ''
    # The tests need access to some of the built utilities
    export PATH="$PATH:$GOPATH/bin"
    # To skip TestCloneBranchAndRefToBucket
    export CI=true
  '';

  installPhase = ''
    runHook preInstall

    # Binaries
    # Only install required binaries, don't install testing binaries
    for FILE in buf protoc-gen-buf-breaking protoc-gen-buf-lint; do
      install -D -m 555 -t $out/bin $GOPATH/bin/$FILE
    done

    # Completions
    installShellCompletion --cmd buf \
      --bash <($GOPATH/bin/buf completion bash) \
      --fish <($GOPATH/bin/buf completion fish) \
      --zsh <($GOPATH/bin/buf completion zsh)

    # Man Pages
    mkdir man && $GOPATH/bin/buf manpages man
    installManPage man/*

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = buf; };

  meta = with lib; {
    homepage = "https://buf.build";
    changelog = "https://github.com/bufbuild/buf/releases/tag/v${version}";
    description = "Create consistent Protobuf APIs that preserve compatibility and comply with design best-practices";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk lrewega ];
  };
}
