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
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VxTJcl7gHRZEXpFbxU4iMwqxuR1r0BNSseWQ5ijWHU4=";
  };
  vendorSha256 = "sha256-szPoJUtzya3+8dOnkDxHEs3+a1LTVoMMLjUSrUlfiGg=";

  enableParallelBuilding = true;
  # needed to build bpf libs
  hardeningDisable = [ "stackprotector" ];

  nativeBuildInputs = [ pkg-config clang ];
  # ensure libbpf version exactly matches the version added as a submodule
  buildInputs = [ libbpf zlib elfutils ];

  makeFlags = [
    "VERSION=v${version}"
    "GO_DEBUG_FLAG=-s -w"
    # don't actually need git but the Makefile checks for it
    "CMD_GIT=echo"
  ];

  # TODO: patch tracee to take libbpf.a and headers via include path
  preBuild = ''
    mkdir -p 3rdparty/libbpf/src
    mkdir -p ./dist
    cp -r ${libbpf}/lib ./dist/libbpf
    chmod +w ./dist/libbpf
    cp -r ${libbpf}/include/bpf ./dist/libbpf/
  '';
  buildPhase = ''
    runHook preBuild
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

    cp ./dist/tracee-ebpf $out/bin
    cp ./dist/tracee-rules $out/bin

    cp -r ./dist/rules $out/share/tracee/
    cp -r ./cmd/tracee-rules/templates $out/share/tracee/

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
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" ];
  };
}
