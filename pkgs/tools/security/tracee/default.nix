{ lib
, buildGoModule
, fetchFromGitHub

, llvmPackages_13
, pkg-config

, zlib
, elfutils
, libbpf

, nixosTests
, testers
, tracee
}:

let
  inherit (llvmPackages_13) clang;
in
buildGoModule rec {
  pname = "tracee";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fAbii/DEXx9WJpolc7amqF9TQj4oE5x0TCiNOtVasGo=";
  };
  vendorSha256 = "sha256-eenhIsiJhPLgwJo2spIGURPkcsec3kO4L5UJ0FWniQc=";

  patches = [
    ./use-our-libbpf.patch
  ];

  enableParallelBuilding = true;
  # needed to build bpf libs
  hardeningDisable = [ "stackprotector" ];

  nativeBuildInputs = [ pkg-config clang ];
  buildInputs = [ elfutils libbpf zlib ];

  makeFlags = [
    "VERSION=v${version}"
    "GO_DEBUG_FLAG=-s -w"
    # don't actually need git but the Makefile checks for it
    "CMD_GIT=echo"
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p ./dist
    make $makeFlags ''${enableParallelBuilding:+-j$NIX_BUILD_CORES} bpf-core all
    runHook postBuild
  '';

  # tests require a separate go module
  # integration tests are ran within a nixos vm
  # see passthru.tests.integration
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/tracee}

    mv ./dist/tracee-{ebpf,rules} $out/bin/

    mv ./dist/rules $out/share/tracee/
    mv ./cmd/tracee-rules/templates $out/share/tracee/

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/tracee-ebpf --help
    $out/bin/tracee-ebpf --version | grep "v${version}"

    $out/bin/tracee-rules --help

    runHook postInstallCheck
  '';

  passthru.tests = {
    integration = nixosTests.tracee;
    version = testers.testVersion {
      package = tracee;
      version = "v${version}";
      command = "tracee-ebpf --version";
    };
  };

  meta = with lib; {
    homepage = "https://aquasecurity.github.io/tracee/latest/";
    changelog = "https://github.com/aquasecurity/tracee/releases/tag/v${version}";
    description = "Linux Runtime Security and Forensics using eBPF";
    longDescription = ''
      Tracee is a Runtime Security and forensics tool for Linux. It is using
      Linux eBPF technology to trace your system and applications at runtime,
      and analyze collected events to detect suspicious behavioral patterns. It
      is delivered as a Docker image that monitors the OS and detects suspicious
      behavior based on a pre-defined set of behavioral patterns.
    '';
    license = with licenses; [
      # general license
      asl20
      # pkg/ebpf/c/*
      gpl2Plus
    ];
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" ];
  };
}
