{ lib, stdenv, fetchFromGitHub, fetchpatch
, llvmPackages, elfutils, bcc
, libbpf, libbfd, libopcodes
, cereal, asciidoctor
, cmake, pkg-config, flex, bison
, util-linux
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "bpftrace";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo  = "bpftrace";
    rev   = "v${version}";
    hash  = "sha256-hwxArrTdjJoab7Twf57PRmRhghV/9EcjRXI0lKRQC0k=";
  };


  buildInputs = with llvmPackages; [
    llvm libclang
    elfutils bcc
    libbpf libbfd libopcodes
    cereal asciidoctor
  ];

  nativeBuildInputs = [
    cmake pkg-config flex bison
    llvmPackages.llvm.dev
    util-linux
  ];

  # tests aren't built, due to gtest shenanigans. see:
  #
  #     https://github.com/iovisor/bpftrace/issues/161#issuecomment-453606728
  #     https://github.com/iovisor/bpftrace/pull/363
  #
  cmakeFlags = [
    "-DBUILD_TESTING=FALSE"
    "-DLIBBCC_INCLUDE_DIRS=${bcc}/include"
    "-DINSTALL_TOOL_DOCS=OFF"
    "-DUSE_SYSTEM_BPF_BCC=ON"
  ];

  # Pull BPF scripts into $PATH (next to their bcc program equivalents), but do
  # not move them to keep `${pkgs.bpftrace}/share/bpftrace/tools/...` working.
  postInstall = ''
    ln -s $out/share/bpftrace/tools/*.bt $out/bin/
  '';

  outputs = [ "out" "man" ];

  passthru.tests = {
    bpf = nixosTests.bpf;
  };

  meta = with lib; {
    description = "High-level tracing language for Linux eBPF";
    homepage    = "https://github.com/iovisor/bpftrace";
    changelog   = "https://github.com/iovisor/bpftrace/releases/tag/v${version}";
    mainProgram = "bpftrace";
    license     = licenses.asl20;
    maintainers = with maintainers; [ rvl thoughtpolice martinetd mfrw ];
  };
}
