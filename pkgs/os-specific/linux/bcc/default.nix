{ stdenv, fetchFromGitHub, makeWrapper, cmake, llvmPackages_5, kernel
, flex, bison, elfutils, python, pythonPackages, luajit, netperf, iperf }:

stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "bcc-${version}";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "bcc";
    rev = "v${version}";
    sha256 = "106ri3yhjhp3dgsjb05y4j6va153d5nqln3zjdz6qfz87svak0rw";
  };

  buildInputs = [
    llvmPackages_5.llvm llvmPackages_5.clang-unwrapped kernel
    elfutils python pythonPackages.netaddr luajit netperf iperf
  ];

  nativeBuildInputs = [ makeWrapper cmake flex bison ];

  postInstall = ''
    mkdir -p $out/bin $out/share
    rm -r $out/share/bcc/tools/old
    mv $out/share/bcc/tools/doc $out/share
    mv $out/share/bcc/man $out/share/

    find $out/share/bcc/tools -type f -executable -print0 | \
    while IFS= read -r -d $'\0' f; do
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
    maintainers = with maintainers; [ ragge ];
  };
}
