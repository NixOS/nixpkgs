{ stdenv, fetchFromGitHub
, cmake, pkgconfig, flex, bison
, llvmPackages, kernel, elfutils, libelf, bcc
}:

stdenv.mkDerivation rec {
  pname = "bpftrace";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner  = "iovisor";
    repo   = "bpftrace";
    rev    = "refs/tags/v${version}";
    sha256 = "17qf1c3h99iyxkc0xzix4jnxwqvxbg9ki23zm7l04qw73lj01g1m";
  };

  enableParallelBuilding = true;

  buildInputs = with llvmPackages;
    [ llvm clang-unwrapped
      kernel elfutils libelf bcc
    ];

  nativeBuildInputs = [ cmake pkgconfig flex bison ]
    # libelf is incompatible with elfutils-libelf
    ++ stdenv.lib.filter (x: x != libelf) kernel.moduleBuildDependencies;

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
      "-DLIBBCC_INCLUDE_DIRS=${bcc}/include/bcc"
    ];

  # nuke the example/reference output .txt files, for the included tools,
  # stuffed inside $out. we don't need them at all.
  postInstall = ''
    rm -rf $out/share/bpftrace/tools/doc
  '';

  outputs = [ "out" "man" ];

  meta = with stdenv.lib; {
    description = "High-level tracing language for Linux eBPF";
    homepage    = https://github.com/iovisor/bpftrace;
    license     = licenses.asl20;
    maintainers = with maintainers; [ rvl thoughtpolice ];
  };
}
