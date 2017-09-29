{ stdenv
, fetchFromGitHub
, libtool
, automake
, autoconf
, python2 # Needed for tests
}:
stdenv.mkDerivation rec {
  name = "libcpuid-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    rev = "v${version}";
    sha256 = "136kv6m666f7s18mim0vdbzqvs4s0wvixa12brj9p3kmfbx48bw7";
  };

  patchPhase = ''
    libtoolize
    autoreconf --install
  '';

  configurePhase = ''
    mkdir -p Install
    ./configure --prefix=$(pwd)/Install
    substituteInPlace Makefile --replace "/usr/local" "$out"
  '';

  buildPhase = ''
    make all
  '';

  postInstall = ''
    pushd Install
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/lib ${python2.interpreter} ../tests/run_tests.py ./bin/cpuid_tool ../tests/
    popd

    function fixRunPath {
      p0=$(patchelf --print-rpath $1)
      p1=$(echo $p0 | sed -re 's#.*Install/lib:##g')
      patchelf --set-rpath $p1 $1
    }

    fixRunPath Install/bin/cpuid_tool

    mkdir -p $out
    sed -i -re "s#(prefix=).*Install#\1$out#g" Install/lib/pkgconfig/libcpuid.pc

    cp -r Install/* $out
    cp -r tests $out
  '';

  nativeBuildInputs = [
    libtool
    automake
    autoconf
  ];

  meta = with stdenv.lib; {
    homepage = http://libcpuid.sourceforge.net/;
    description = "a small C library for x86 CPU detection and feature extraction";
    license = licenses.bsd3;
    maintainers = with maintainers; [ artuuge ];
  };
}
