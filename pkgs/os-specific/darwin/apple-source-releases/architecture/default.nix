{ stdenv, appleDerivation }:

appleDerivation {
  dontBuild = true;

  installPhase = ''
    export DSTROOT=$out
    make install
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
