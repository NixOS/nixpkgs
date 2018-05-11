{ stdenv, appleDerivation }:

appleDerivation {
  dontBuild = true;

  postPatch = ''
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
