{ stdenv, fetchFromGitHub, fetchpatch, makeWrapper, cmake, llvmPackages, kernel
, flex, bison, elfutils, python, pythonPackages, luajit, netperf, iperf, libelf
, systemtap
}:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "bcc-${version}";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "bcc";
    rev = "v${version}";
    sha256 = "0bb3244xll5sqx0lvrchg71qy2zg0yj6r5h4v5fvrg1fjhaldys9";
  };

  buildInputs = [
    llvmPackages.llvm llvmPackages.clang-unwrapped kernel
    elfutils python pythonPackages.netaddr luajit netperf iperf
    systemtap.stapBuild
  ];

  patches = [
    # fix build with llvm > 5.0.0 && < 6.0.0
    (fetchpatch {
      url = "https://github.com/iovisor/bcc/commit/bd7fa55bb39b8978dafd0b299e35616061e0a368.patch";
      sha256 = "1sgxhsq174iihyk1x08py73q8fh78d7y3c90k5nh8vcw2pf1xbnf";
    })
  ];

  nativeBuildInputs = [ makeWrapper cmake flex bison ]
    # libelf is incompatible with elfutils-libelf
    ++ stdenv.lib.filter (x: x != libelf) kernel.moduleBuildDependencies;

  cmakeFlags =
    [ "-DBCC_KERNEL_MODULES_DIR=${kernel.dev}/lib/modules"
      "-DREVISION=${version}"
      "-DENABLE_USDT=ON"
      "-DENABLE_CPP_API=ON"
    ];

  postInstall = ''
    mkdir -p $out/bin $out/share
    rm -r $out/share/bcc/tools/old
    mv $out/share/bcc/tools/doc $out/share
    mv $out/share/bcc/man $out/share/

    find $out/share/bcc/tools -type f -executable -print0 | \
    while IFS= read -r -d ''$'\0' f; do
      pythonLibs="$out/lib/python2.7/site-packages:${pythonPackages.netaddr}/lib/${python.libPrefix}/site-packages"
      rm -f $out/bin/$(basename $f)
      makeWrapper $f $out/bin/$(basename $f) \
        --prefix LD_LIBRARY_PATH : $out/lib \
        --prefix PYTHONPATH : "$pythonLibs"
    done
  '';

  meta = with stdenv.lib; {
    description = "Dynamic Tracing Tools for Linux";
    homepage = https://iovisor.github.io/bcc/;
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge mic92 ];
  };
}
