{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, flex, bison
, llvmPackages, elfutils
, libbfd, libbpf, libopcodes, bcc
, cereal, asciidoctor
, nixosTests
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "bpftrace";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner  = "iovisor";
    repo   = "bpftrace";
    rev    = "v${version}";
    sha256 = "sha256-dEchHXZPWc+/Dui6P65EqxB8O/M7F47PZVsKSp80oXE=";
  };

  buildInputs = with llvmPackages;
    [ llvm libclang
      elfutils bcc
      libbpf libbfd libopcodes
      cereal asciidoctor
    ];

  nativeBuildInputs = [ cmake pkg-config flex bison llvmPackages.llvm.dev util-linux ];

  # tests aren't built, due to gtest shenanigans. see:
  #
  #     https://github.com/iovisor/bpftrace/issues/161#issuecomment-453606728
  #     https://github.com/iovisor/bpftrace/pull/363
  #
  cmakeFlags =
    [ "-DBUILD_TESTING=FALSE"
      "-DLIBBCC_INCLUDE_DIRS=${bcc}/include"
      "-DINSTALL_TOOL_DOCS=off"
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
    license     = licenses.asl20;
    maintainers = with maintainers; [ rvl thoughtpolice martinetd ];
  };
}
