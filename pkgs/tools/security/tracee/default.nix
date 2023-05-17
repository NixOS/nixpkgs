{ lib
, buildGoModule
, fetchFromGitHub

, clang
, pkg-config

, zlib
, elfutils
, libbpf

, nixosTests
, testers
, tracee
}:

buildGoModule rec {
  pname = "tracee";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YO5u/hE5enoqh8niV4Zi+NFUsU+UXCCxdqvxolZImGk=";
  };
  vendorHash = "sha256-swMvJe+Dz/kwPIStPlQ7d6U/UwXSMcJ3eONxjzebXCc=";

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

  outputs = [ "out" "lib" "share" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $lib/lib/tracee $share/share/tracee

    mv ./dist/tracee $out/bin/
    mv ./dist/tracee.bpf.core.o $lib/lib/tracee/
    mv ./cmd/tracee-rules/templates $share/share/tracee/

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/tracee --help
    $out/bin/tracee --version | grep "v${version}"

    runHook postInstallCheck
  '';

  passthru.tests = {
    integration = nixosTests.tracee;
    version = testers.testVersion {
      package = tracee;
      version = "v${version}";
      command = "tracee --version";
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
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    outputsToInstall = [ "out" "share" ];
  };
}
