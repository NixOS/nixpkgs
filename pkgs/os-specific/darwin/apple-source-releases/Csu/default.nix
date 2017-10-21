{ stdenv, appleDerivation }:

appleDerivation {
  postUnpack = ''
    substituteInPlace $sourceRoot/Makefile \
      --replace "/usr/lib" "/lib" \
      --replace "/usr/local/lib" "/lib" \
      --replace "/usr/bin" "" \
      --replace "/bin/" "" \
      --replace "CC = " "CC = cc #" \
      --replace "SDK_DIR = " "SDK_DIR = . #"
  '';

  # Mac OS didn't support rpaths back before 10.5, and this package intentionally builds stubs targeting versions prior to that
  NIX_DONT_SET_RPATH = "1";
  NIX_NO_SELF_RPATH  = "1";

  installPhase = ''
    export DSTROOT=$out
    make install
  '';

  meta = with stdenv.lib; {
    description = "Apple's common startup stubs for darwin";
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
