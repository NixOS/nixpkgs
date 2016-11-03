{ stdenv, fetchFromGitHub, makeWrapper, cmake, llvmPackages, kernel,
  flex, bison, elfutils, python, pythonPackages, luajit, netperf, iperf }:

stdenv.mkDerivation rec {
  version = "git-2016-11-02";
  name = "bcc-${version}";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "bcc";
    rev = "5496aaf390472e3c3547201b1a3c9640fc49032b";
    sha256 = "0s4kpmnk55qn6y3755c45ca7vbpgsgik5520qkp70wz8sg6s3xa8";
  };

  nativeBuildInputs = [ makeWrapper cmake ];
  buildInputs = [
    llvmPackages.llvm llvmPackages.clang-unwrapped kernel
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
