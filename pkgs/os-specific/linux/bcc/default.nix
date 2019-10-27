{ stdenv, fetchFromGitHub, makeWrapper, cmake, llvmPackages, kernel
, flex, bison, elfutils, python, luajit, netperf, iperf, libelf
, systemtap
}:

python.pkgs.buildPythonApplication rec {
  version = "0.11.0";
  name = "bcc-${version}";

  srcs = [
    (fetchFromGitHub {
      owner  = "iovisor";
      repo   = "bcc";
      rev    = "v${version}";
      sha256 = "1v2gzdd4k58f3yxmq4z97a7xh5vyd84flzzfr9k2cm29i93cwcam";
      name   = "bcc";
    })

    # note: keep this in sync with the version that was used at the time of the
    # tagged release!
    (fetchFromGitHub {
      owner  = "libbpf";
      repo   = "libbpf";
      rev    = "a30df5c09fb3941fc42c4570ed2545e7057bf82a";
      sha256 = "088vb9sfs1zazlqi6abb3ia1xgpmwiz5pmz6y3a6gbh0zdrgh6px";
      name   = "libbpf";
    })
  ];
  sourceRoot = "bcc";
  format = "other";

  buildInputs = with llvmPackages; [
    llvm clang-unwrapped kernel
    elfutils luajit netperf iperf
    systemtap.stapBuild flex
  ];

  patches = [
    # This is needed until we fix
    # https://github.com/NixOS/nixpkgs/issues/40427
    ./fix-deadlock-detector-import.patch
  ];

  propagatedBuildInputs = [ python.pkgs.netaddr ];
  nativeBuildInputs = [ makeWrapper cmake flex bison ]
    # libelf is incompatible with elfutils-libelf
    ++ stdenv.lib.filter (x: x != libelf) kernel.moduleBuildDependencies;

  cmakeFlags = [
    "-DBCC_KERNEL_MODULES_DIR=${kernel.dev}/lib/modules"
    "-DREVISION=${version}"
    "-DENABLE_USDT=ON"
    "-DENABLE_CPP_API=ON"
  ];

  postPatch = ''
    substituteAll ${./libbcc-path.patch} ./libbcc-path.patch
    patch -p1 < libbcc-path.patch
  '';

  preConfigure = ''
    chmod -R u+w ../libbpf/
    rmdir src/cc/libbpf
    (cd src/cc && ln -svf ../../../libbpf/ libbpf)
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
    done

    sed -i -e "s!lib=.*!lib=$out/bin!" $out/bin/{java,ruby,node,python}gc
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/bcc/tools" "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "Dynamic Tracing Tools for Linux";
    homepage    = https://iovisor.github.io/bcc/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ ragge mic92 thoughtpolice ];
  };
}
