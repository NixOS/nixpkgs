{
  lib,
  buildGoModule,
  fetchFromGitHub,

  clang,
  pkg-config,

  zlib,
  elfutils,
  libbpf,

  nixosTests,
  testers,
  tracee,
  makeWrapper,
}:

buildGoModule rec {
  pname = "tracee";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    # project has branches and tags of the same name
    rev = "refs/tags/v${version}";
    hash = "sha256-OnOayDxisvDd802kDKGctaQc5LyoyFfdfvC+2JpRjHY=";
  };
  vendorHash = "sha256-26sAKTJQ7Rf5KRlu7j5XiZVr6CkAC6fm60Pam7KH0uA=";

  patches = [
    ./use-our-libbpf.patch
    # can not vendor dependencies with old pyroscope
    # remove once https://github.com/aquasecurity/tracee/pull/3927
    # makes it to a release
    ./update-pyroscope.patch
  ];

  enableParallelBuilding = true;
  # needed to build bpf libs
  hardeningDisable = [ "stackprotector" ];

  nativeBuildInputs = [
    pkg-config
    clang
  ];
  buildInputs = [
    elfutils
    libbpf
    zlib
  ];

  makeFlags = [
    "VERSION=v${version}"
    "GO_DEBUG_FLAG=-s -w"
    # don't actually need git but the Makefile checks for it
    "CMD_GIT=echo"
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p ./dist
    make $makeFlags ''${enableParallelBuilding:+-j$NIX_BUILD_CORES} bpf all
    runHook postBuild
  '';

  # tests require a separate go module
  # integration tests are ran within a nixos vm
  # see passthru.tests.integration
  doCheck = false;

  outputs = [
    "out"
    "lib"
    "share"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $lib/lib/tracee $share/share/tracee

    mv ./dist/{tracee,signatures} $out/bin/
    mv ./dist/tracee.bpf.o $lib/lib/tracee/
    mv ./cmd/tracee-rules/templates $share/share/tracee/

    runHook postInstall
  '';

  passthru.tests = {
    integration = nixosTests.tracee;
    integration-test-cli = import ./integration-tests.nix { inherit lib tracee makeWrapper; };
    version = testers.testVersion {
      package = tracee;
      version = "v${version}";
      command = "tracee version";
    };
  };

  meta = with lib; {
    homepage = "https://aquasecurity.github.io/tracee/latest/";
    changelog = "https://github.com/aquasecurity/tracee/releases/tag/v${version}";
    description = "Linux Runtime Security and Forensics using eBPF";
    mainProgram = "tracee";
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    outputsToInstall = [
      "out"
      "share"
    ];
  };
}
