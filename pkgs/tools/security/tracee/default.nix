{ lib
, buildGoModule
, fetchFromGitHub

, llvmPackages_13
, pkg-config

, zlib
, libelf
}:

let
  inherit (llvmPackages_13) clang;
  clang-with-bpf =
    (clang.overrideAttrs (o: { pname = o.pname + "-with-bpf"; })).override (o: {
      extraBuildCommands = o.extraBuildCommands + ''
        # make a separate wrapped clang we can target at bpf
        cp $out/bin/clang $out/bin/clang-bpf
        # extra flags to append after the cc-cflags
        echo '-target bpf -fno-stack-protector' > $out/nix-support/cc-cflags-bpf
        # use sed to attach the cc-cflags-bpf after cc-cflags
        sed -i -E "s@^(extraAfter=\(\\$\NIX_CFLAGS_COMPILE_.*)(\))\$@\1 $(cat $out/nix-support/cc-cflags-bpf)\2@" $out/bin/clang-bpf
      '';
    });
in
buildGoModule rec {
  pname = "tracee";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Y++FWxADnj1W5S3VrAlJAnotFYb6biCPJ6dpQ0Nin8o=";
    # Once libbpf hits 1.0 we will migrate to the nixpkgs libbpf rather than the
    # pinned copy in submodules
    fetchSubmodules = true;
  };
  vendorSha256 = "sha256-C2RExp67qax8+zJIgyMJ18sBtn/xEYj4tAvGCCpBssQ=";

  patches = [
    # bpf-core can't be compiled with wrapped clang since it forces the target
    # we need to be able to replace it with another wrapped clang that has
    # it's target as bpf
    ./bpf-core-clang-bpf.patch
    # add -s to ldflags for smaller binaries
    ./disable-go-symbol-table.patch
  ];


  enableParallelBuilding = true;

  strictDeps = true;
  nativeBuildInputs = [ pkg-config clang-with-bpf ];
  buildInputs = [ zlib libelf ];

  makeFlags = [
    "VERSION=v${version}"
    "CMD_CLANG_BPF=clang-bpf"
    # don't actually need git but the Makefile checks for it
    "CMD_GIT=echo"
  ];

  buildPhase = ''
    runHook preBuild
    make $makeFlags ''${enableParallelBuilding:+-j$NIX_BUILD_CORES -l$NIX_BUILD_CORES}
    runHook postBuild
  '';

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
