{ lib, stdenv, fetchFromGitHub
, makeWrapper, cmake, llvmPackages, kernel
, flex, bison, elfutils, python, luajit, netperf, iperf, libelf
, systemtap, bash, libbpf
}:

python.pkgs.buildPythonApplication rec {
  pname = "bcc";
  version = "0.19.0";

  disabled = !stdenv.isLinux;

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "bcc";
    rev = "v${version}";
    sha256 = "sha256:0k807vzznlb2icczw64ph6q28605kvghya2kd4h3c7jmap6gq1qg";
  };
  format = "other";

  buildInputs = with llvmPackages; [
    llvm clang-unwrapped kernel
    elfutils luajit netperf iperf
    systemtap.stapBuild flex bash
    libbpf
  ];

  patches = [
    # This is needed until we fix
    # https://github.com/NixOS/nixpkgs/issues/40427
    ./fix-deadlock-detector-import.patch
  ];

  propagatedBuildInputs = [ python.pkgs.netaddr ];
  nativeBuildInputs = [ makeWrapper cmake flex bison ]
    # libelf is incompatible with elfutils-libelf
    ++ lib.filter (x: x != libelf) kernel.moduleBuildDependencies;

  cmakeFlags = [
    "-DBCC_KERNEL_MODULES_DIR=${kernel.dev}/lib/modules"
    "-DREVISION=${version}"
    "-DENABLE_USDT=ON"
    "-DENABLE_CPP_API=ON"
    "-DCMAKE_USE_LIBBPF_PACKAGE=ON"
  ];

  postPatch = ''
    substituteAll ${./libbcc-path.patch} ./libbcc-path.patch
    patch -p1 < libbcc-path.patch
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

  meta = with lib; {
    description = "Dynamic Tracing Tools for Linux";
    homepage    = "https://iovisor.github.io/bcc/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ ragge mic92 thoughtpolice ];
  };
}
