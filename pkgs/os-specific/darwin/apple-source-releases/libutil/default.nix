{ stdenv, appleDerivation }:

# all symbols are located in libSystem
appleDerivation {
  installPhase = ''
    mkdir -p $out/include
    cp *.h $out/include
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
