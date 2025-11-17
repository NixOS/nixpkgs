{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  git,
  sigtool,
  testers,
  linuxkit,
}:

buildGoModule rec {
  pname = "linuxkit";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    rev = "v${version}";
    sha256 = "sha256-0W3YWj6amNI6jr10FfLAqF1kEUwx4BU5+gjkg4iqX1Q=";
  };

  vendorHash = null;

  modRoot = "./src/cmd/linuxkit";

  patches = [
    ./darwin-os-version.patch
    ./support-apple-11-sdk.patch
  ];

  # - On macOS, an executable must be signed with the right entitlement(s) to be
  #   able to use the Virtualization framework at runtime.
  # - sigtool is allows us to validly sign such executables with a dummy
  #   authority.
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ sigtool ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/linuxkit/linuxkit/src/cmd/linuxkit/version.Version=${version}"
  ];

  nativeCheckInputs = [ git ];

  # - Because this package definition doesn't build using the source's Makefile,
  #   we must manually call the sign target.
  # - The binary stripping that nixpkgs does by default in the
  #   fixup phase removes such signing and entitlements, so we have to sign
  #   after stripping.
  # - Finally, at the start of the fixup phase, the working directory is
  #   $sourceRoot/src/cmd/linuxkit, so it's simpler to use the sign target from
  #   the Makefile in that directory rather than $sourceRoot/Makefile.
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    make sign LOCAL_TARGET=$out/bin/linuxkit
  '';
  passthru.tests.version = testers.testVersion {
    package = linuxkit;
    command = "linuxkit version";
  };

  meta = with lib; {
    description = "Toolkit for building secure, portable and lean operating systems for containers";
    mainProgram = "linuxkit";
    license = licenses.asl20;
    homepage = "https://github.com/linuxkit/linuxkit";
    maintainers = with maintainers; [ nicknovitski ];
  };
}
