{ lib, stdenv, fetchFromGitHub
, makeWrapper, cmake, llvmPackages
, flex, bison, elfutils, python, luajit, netperf, iperf, libelf
, bash, libbpf, nixosTests
, audit
}:

python.pkgs.buildPythonApplication rec {
  pname = "bcc";
  version = "0.26.0";

  disabled = !stdenv.isLinux;

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "bcc";
    rev = "v${version}";
    sha256 = "sha256-zx38tPwuuGU6px9pRNN5JtvBysK9fStOvoqe7cLo7LM=";
  };
  format = "other";

  buildInputs = with llvmPackages; [
    llvm llvm.dev libclang
    elfutils luajit netperf iperf
    flex bash libbpf
  ];

  patches = [
    # This is needed until we fix
    # https://github.com/NixOS/nixpkgs/issues/40427
    ./fix-deadlock-detector-import.patch
  ];

  propagatedBuildInputs = [ python.pkgs.netaddr ];
  nativeBuildInputs = [ makeWrapper cmake flex bison llvmPackages.llvm.dev ];

  cmakeFlags = [
    "-DBCC_KERNEL_MODULES_DIR=/run/booted-system/kernel-modules/lib/modules"
    "-DREVISION=${version}"
    "-DENABLE_USDT=ON"
    "-DENABLE_CPP_API=ON"
    "-DCMAKE_USE_LIBBPF_PACKAGE=ON"
  ];

  # to replace this executable path:
  # https://github.com/iovisor/bcc/blob/master/src/python/bcc/syscall.py#L384
  ausyscall = "${audit}/bin/ausyscall";

  postPatch = ''
    substituteAll ${./libbcc-path.patch} ./libbcc-path.patch
    patch -p1 < libbcc-path.patch

    substituteAll ${./absolute-ausyscall.patch} ./absolute-ausyscall.patch
    patch -p1 < absolute-ausyscall.patch

    # https://github.com/iovisor/bcc/issues/3996
    substituteInPlace src/cc/libbcc.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share
    rm -r $out/share/bcc/tools/old
    mv $out/share/bcc/tools/doc $out/share
    mv $out/share/bcc/man $out/share/

    find $out/share/bcc/tools -type f -executable -print0 | \
    while IFS= read -r -d ''$'\0' f; do
      bin=$out/bin/$(basename $f)
      if [ ! -e $bin ]; then
        ln -s $f $bin
      fi
      substituteInPlace "$f" \
        --replace '$(dirname $0)/lib' "$out/share/bcc/tools/lib"
    done

    sed -i -e "s!lib=.*!lib=$out/bin!" $out/bin/{java,ruby,node,python}gc
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/bcc/tools" "$out $pythonPath"
  '';

  outputs = [ "out" "man" ];

  passthru.tests = {
    bpf = nixosTests.bpf;
  };

  meta = with lib; {
    description = "Dynamic Tracing Tools for Linux";
    homepage    = "https://iovisor.github.io/bcc/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ ragge mic92 thoughtpolice martinetd ];
  };
}
