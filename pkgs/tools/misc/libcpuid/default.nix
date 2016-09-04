{ stdenv
, fetchgit
, libtool
, automake
, autoconf
, python
}:
stdenv.mkDerivation rec {
  name = "libcpuid-${version}";
  version = "0.2.2";

  src = fetchgit {
    url = https://github.com/anrieff/libcpuid.git;
    rev = "535ec64dd9d8df4c5a8d34b985280b58a5396fcf";
    sha256 = "1j9pg7fyvqhr859k5yh8ccl9jjx65c7rrsddji83qmqyg0vp1k1a";
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
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/lib ${python.interpreter} ../tests/run_tests.py ./bin/cpuid_tool ../tests/
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

  buildInputs = [
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
