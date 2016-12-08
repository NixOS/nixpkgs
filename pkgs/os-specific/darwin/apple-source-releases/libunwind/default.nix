{ stdenv, appleDerivation, dyld, osx_private_sdk }:

appleDerivation {
  buildPhase = ":";

  # install headers only
  installPhase = ''
    mkdir -p $out/lib
    make install-data-am
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin lnl7 ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
