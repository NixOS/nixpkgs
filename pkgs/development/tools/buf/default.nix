{ lib
, buildGoModule
, fetchFromGitHub
, protobuf
, git
, testVersion
, buf
, installShellFiles
}:

buildGoModule rec {
  pname = "buf";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8GwZsFvxaTtG/q7DaWvZcGdbyJ4Cm41BqSvwq3SqoEg=";
  };

  vendorSha256 = "sha256-g3bvfNF0XkC12/tRZsO+o2z20w+riWiHOer8Pzp1QF0=";

  patches = [
    # Skip a test that requires networking to be available to work.
    ./skip_test_requiring_network.patch
    # Skip TestWorkspaceGit which requires .git and commits.
    ./skip_test_requiring_dotgit.patch
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
    mkdir -p "$out/bin"
    # Only install required binaries, don't install testing binaries
    for FILE in \
      "buf" \
      "protoc-gen-buf-breaking" \
      "protoc-gen-buf-lint"; do
      cp "$GOPATH/bin/$FILE" "$out/bin/"
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

  passthru.tests.version = testVersion { package = buf; };

  meta = with lib; {
    homepage = "https://buf.build";
    changelog = "https://github.com/bufbuild/buf/releases/tag/v${version}";
    description = "Create consistent Protobuf APIs that preserve compatibility and comply with design best-practices";
    license = licenses.asl20;
    maintainers = with maintainers; [ raboof jk lrewega ];
  };
}
