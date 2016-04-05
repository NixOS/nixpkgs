{ stdenv, fetchFromGitHub, makeWrapper, cmake, llvmPackages, kernel,
  flex, bison, elfutils, python, pythonPackages, luajit, netperf, iperf }:

stdenv.mkDerivation rec {
  version = "git-2016-05-18";
  name = "bcc-${version}";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "bcc";
    rev = "c7f317deb577d59007411e978ac21a2ea376358f";
    sha256 = "0jv4smy615kp7623pd61s46m52jjp6m47w0fjgr7s22qamra3g98";
  };

  buildInputs = [ makeWrapper cmake llvmPackages.llvm llvmPackages.clang-unwrapped kernel
    flex bison elfutils python pythonPackages.netaddr luajit netperf iperf
  ];

  cmakeFlags="-DBCC_KERNEL_MODULES_DIR=${kernel.dev}/lib/modules -DBCC_KERNEL_HAS_SOURCE_DIR=1";
    
  postInstall = ''
    mkdir -p $out/bin
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
