{ stdenv, appleDerivation }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" ];

  postUnpack = ''
    substituteInPlace $sourceRoot/Makefile \
      --replace "/usr/include" "/include" \
      --replace "/usr/bin/" "" \
      --replace "/bin/" ""
  '';

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
