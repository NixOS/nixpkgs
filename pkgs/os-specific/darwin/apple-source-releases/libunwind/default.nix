{ stdenv, appleDerivation, dyld }:

appleDerivation {
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildInputs = [ dyld ];

  buildPhase = ''
    # cd src
    # cc -I$PWD/../include -c libuwind.cxx
    # cc -I$PWD/../include -c Registers.s
    # cc -I$PWD/../include -c unw_getcontext.s
    # cc -I$PWD/../include -c UnwindLevel1.c
    # cc -I$PWD/../include -c UnwindLevel1-gcc-ext.c
    # cc -I$PWD/../include -c Unwind-sjlj.c
  '';

  installPhase = ''
    mkdir -p $out

    cp -r include $out
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
