{ lib, stdenv, buildGoModule, fetchFromGitHub, git, Cocoa, Virtualization, sigtool, testers, linuxkit }:

buildGoModule rec {
  pname = "linuxkit";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    rev = "v${version}";
    sha256 = "sha256-Tcc2FdZ0h97r1C5BMTVb45HB8AuN/wPD+A8samhaJY8=";
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
  nativeBuildInputs = lib.optionals stdenv.isDarwin [ sigtool ];
  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa Virtualization ];

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
  postFixup = lib.optionalString stdenv.isDarwin ''
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
