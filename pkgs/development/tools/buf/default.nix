{ lib
, buildGoModule
, fetchFromGitHub
, protobuf
, git
}:

buildGoModule rec {
  pname = "buf";
  version = "0.43.2";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Go0wLcJrxMgB67WlAI7TwX2UU2sQ/yfmC0h2igOkjc4=";
    leaveDotGit = true; # Required by TestWorkspaceGit
  };
  vendorSha256 = "sha256-HT0dsGniBoQW2Y7MhahDeFvE0nCASoPdzHETju0JuRY=";

  patches = [
    ./skip_test_requiring_network.patch
  ];

  nativeBuildInputs = [ protobuf ];
  checkInputs = [ git ];

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    export PATH=$PATH:$GOPATH/bin
    # To skip TestCloneBranchAndRefToBucket
    export CI=true
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    dir="$GOPATH/bin"
    # Only install required binaries, don't install testing binaries
    for file in \
      "buf" \
      "protoc-gen-buf-breaking" \
      "protoc-gen-buf-lint" \
      "protoc-gen-buf-check-breaking" \
      "protoc-gen-buf-check-lint"; do
      cp "$dir/$file" "$out/bin/"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Create consistent Protobuf APIs that preserve compatibility and comply with design best-practices";
    homepage = "https://buf.build";
    license = licenses.asl20;
    maintainers = with maintainers; [ raboof ];
  };
}
