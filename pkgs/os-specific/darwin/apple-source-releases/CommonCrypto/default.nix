{ stdenv, appleDerivation }:

appleDerivation {
  installPhase = ''
    mkdir -p $out/include/CommonCrypto
    cp include/* $out/include/CommonCrypto
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
