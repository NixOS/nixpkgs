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
<<<<<<< HEAD
  version = "1.26.1";
=======
  version = "1.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-e00o3G66GCJyA3flqRa+J1yQVBVusBrEOJrL9viKtlM=";
  };

  vendorHash = "sha256-7RVYD0r3nqb0yLmKu9zzpQNiVDVBJGG1BiVb6J+VR9k=";
=======
    hash = "sha256-wMYl9TlOQ4h5MFNNWaGkou7YIBSsMfhV70ABgKkC7xo=";
  };

  vendorHash = "sha256-pyhK0tHpHrEkGRkWgzTFg9FNNBx3SwoWUfw+2zk7nAs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patches = [
    # Skip a test that requires networking to be available to work.
    ./skip_test_requiring_network.patch
<<<<<<< HEAD
=======
    # Skip TestWorkspaceGit which requires .git and commits.
    ./skip_test_requiring_dotgit.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    # To skip TestCloneBranchAndRefToBucket
    export CI=true
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
