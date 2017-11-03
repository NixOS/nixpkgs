{ stdenv, appleDerivation }:

appleDerivation {
  buildPhase = ":";

  # install headers only
  installPhase = ''
    mkdir -p $out/lib
    cp -R include $out/include
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin lnl7 ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
