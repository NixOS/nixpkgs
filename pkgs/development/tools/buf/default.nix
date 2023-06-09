{ lib
, buildGoModule
, fetchFromGitHub
, protobuf
, git
, testers
, buf
, installShellFiles
}:

buildGoModule rec {
  pname = "buf";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7aS48tfONrDdE+NoTpoz+5TOBDQfEgCwKKkoBnrUTW8=";
  };

  vendorHash = "sha256-zk7cj3DwfaZg7PRS50qw0tS8lguX4yWcCiPk+2HYah8=";

  patches = [
    # Skip a test that requires networking to be available to work.
    ./skip_test_requiring_network.patch
  ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  nativeCheckInputs = [
    git # Required for TestGitCloner
    protobuf # Required for buftesting.GetProtocFilePaths
  ];

  preCheck = ''
    # The tests need access to some of the built utilities
    export PATH="$PATH:$GOPATH/bin"
  '';

  # Allow tests that bind or connect to localhost on macOS.
  __darwinAllowLocalNetworking = true;

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
