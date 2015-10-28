{ stdenv, appleDerivation, dyld, osx_private_sdk }:

appleDerivation {
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildInputs = [ dyld ];

  NIX_CFLAGS_COMPILE = "-I${osx_private_sdk}/PrivateSDK10.9.sparse.sdk/usr/include";

  buildPhase = ''
    pushd src
    c++ -I../include -c libuwind.cxx -o libuwind.o
    cc  -I../include -c Registers.s -o Registers.o
    cc  -I../include -c unw_getcontext.s -o unw_getcontext.o
    cc  -I../include -c UnwindLevel1.c -o UnwindLevel1.o
    cc  -I../include -c UnwindLevel1-gcc-ext.c -o UnwindLevel1-gcc-ext.o
    cc  -I../include -c Unwind-sjlj.c -o Unwind-sjlj.o
    ld -arch x86_64 -dylib libuwind.o Registers.o unw_getcontext.o UnwindLevel1.o UnwindLevel1-gcc-ext.o Unwind-sjlj.o \
      -lc++ -lc -install_name $out/lib/libunwind.dylib -o libunwind.dylib
    popd
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -R include $out/include
    install -m 0755 src/libunwind.dylib $out/lib
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
