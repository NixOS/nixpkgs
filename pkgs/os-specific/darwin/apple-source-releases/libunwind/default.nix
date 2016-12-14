{ stdenv, appleDerivation, dyld, osx_private_sdk }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib
    cp -R include $out/include
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
