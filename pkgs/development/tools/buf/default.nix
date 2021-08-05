{ lib
, buildGoModule
, fetchFromGitHub
, protobuf
, git
}:

buildGoModule rec {
  pname = "buf";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5mjk31HuPNO/RhmMhIm3dAZAED/Kk33ObjC8KbPKRxk=";
    leaveDotGit = true; # Required by TestWorkspaceGit
  };
  vendorSha256 = "sha256-K8UZDEhAvD292RCEDKfY9PdZGS389vLF3oukcBndUF4=";

  patches = [
    # Skip a test that requires networking to be available to work.
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
