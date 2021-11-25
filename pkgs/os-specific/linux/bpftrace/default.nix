{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, flex, bison
, llvmPackages, kernel, elfutils
, libelf, libbfd, libbpf, libopcodes, bcc
}:

stdenv.mkDerivation rec {
  pname = "bpftrace";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner  = "iovisor";
    repo   = "bpftrace";
    rev    = "v${version}";
    sha256 = "sha256-BKWBdFzj0j7rAfG30A0fwyYCpOG/5NFRPODW46EP1u0=";
  };

  buildInputs = with llvmPackages;
    [ llvm libclang
      kernel elfutils libelf bcc
      libbpf libbfd libopcodes
    ];

  nativeBuildInputs = [ cmake pkg-config flex bison llvmPackages.llvm.dev ]
    # libelf is incompatible with elfutils-libelf
    ++ lib.filter (x: x != libelf) kernel.moduleBuildDependencies;

  # patch the source, *then* substitute on @NIX_KERNEL_SRC@ in the result. we could
  # also in theory make this an environment variable around bpftrace, but this works
  # nicely without wrappers.
  patchPhase = ''
    patch -p1 < ${./fix-kernel-include-dir.patch}
    substituteInPlace ./src/utils.cpp \
      --subst-var-by NIX_KERNEL_SRC '${kernel.dev}/lib/modules/${kernel.modDirVersion}'
  '';

  # tests aren't built, due to gtest shenanigans. see:
  #
  #     https://github.com/iovisor/bpftrace/issues/161#issuecomment-453606728
  #     https://github.com/iovisor/bpftrace/pull/363
  #
  cmakeFlags =
    [ "-DBUILD_TESTING=FALSE"
      "-DLIBBCC_INCLUDE_DIRS=${bcc}/include"
    ];

  # nuke the example/reference output .txt files, for the included tools,
  # stuffed inside $out. we don't need them at all.
  postInstall = ''
    rm -rf $out/share/bpftrace/tools/doc
  '';

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "High-level tracing language for Linux eBPF";
    homepage    = "https://github.com/iovisor/bpftrace";
    license     = licenses.asl20;
    maintainers = with maintainers; [ rvl thoughtpolice ];
  };
}
