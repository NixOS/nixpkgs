{ lib
, buildGoModule
, fetchFromGitHub
, protobuf
, git
, testVersion
, buf
}:

buildGoModule rec {
  pname = "buf";
  version = "1.0.0-rc8";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Oye+nYvKdT9t36hAMJSAJZCOQ2L3rHSjhjIu9gU2MWo=";
  };
  vendorSha256 = "sha256-aZv44ZPW/bJ8TEXU79ExREj2DH6j7J1+E/E1yh13Hvc=";

  patches = [
    # Skip a test that requires networking to be available to work.
    ./skip_test_requiring_network.patch
    # Skip TestWorkspaceGit which requires .git and commits.
    ./skip_test_requiring_dotgit.patch
  ];

  nativeBuildInputs = [ protobuf ];
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

    mkdir -p "$out/bin"
    # Only install required binaries, don't install testing binaries
    for FILE in \
      "buf" \
      "protoc-gen-buf-breaking" \
      "protoc-gen-buf-lint"; do
      cp "$GOPATH/bin/$FILE" "$out/bin/"
    done

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
