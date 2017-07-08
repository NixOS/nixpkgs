{ stdenv, fetchFromGitHub, makeWrapper, cmake, llvmPackages, kernel,
  flex, bison, elfutils, python, pythonPackages, luajit, netperf, iperf }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "bcc-${version}";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "bcc";
    rev = "v${version}";
    sha256 = "19lkqmilfjmj7bnhxlacd0waa5db8gf4lng12fy2zgji0d77vm1d";
  };

  buildInputs = [ makeWrapper cmake llvmPackages.llvm llvmPackages.clang-unwrapped kernel
    flex bison elfutils python pythonPackages.netaddr luajit netperf iperf
  ];

  cmakeFlags="-DBCC_KERNEL_MODULES_DIR=${kernel.dev}/lib/modules -DBCC_KERNEL_HAS_SOURCE_DIR=1";

  postInstall = ''
    mkdir -p $out/bin $out/share
    rm -r $out/share/bcc/tools/{old,doc/CMakeLists.txt}
    mv $out/share/bcc/tools/doc $out/share
    mv $out/share/bcc/man $out/share/

    for f in $out/share/bcc/tools\/*; do
      ln -s $f $out/bin/$(basename $f)
      wrapProgram $f \
        --prefix LD_LIBRARY_PATH : $out/lib \
        --prefix PYTHONPATH : $out/lib/python2.7/site-packages \
        --prefix PYTHONPATH : :${pythonPackages.netaddr}/lib/${python.libPrefix}/site-packages
    done
  '';

  meta = with stdenv.lib; {
    description = "Dynamic Tracing Tools for Linux";
    homepage = "https://iovisor.github.io/bcc/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge ];
  };
}
