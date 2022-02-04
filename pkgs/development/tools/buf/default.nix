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
  version = "1.0.0-rc12";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UqyWQdlCDTSjW348f87W7g2kwB5nzIOviSE5/1T1soY=";
  };
  vendorSha256 = "sha256-qBgGZTok3G0Pgku76uiV9bZperhiSNoWSrzxrHe4QXw=";

  patches = [
    # Skip a test that requires networking to be available to work.
    ./skip_test_requiring_network.patch
    # Skip TestWorkspaceGit which requires .git and commits.
    ./skip_test_requiring_dotgit.patch
  ];

  nativeBuildInputs = [ protobuf installShellFiles ];
  # Required for TestGitCloner
  checkInputs = [ git ];

  ldflags = [ "-s" "-w" ];

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
      --bash <($GOPATH/bin/buf bash-completion) \
      --fish <($GOPATH/bin/buf fish-completion) \
      --zsh <($GOPATH/bin/buf zsh-completion)

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
