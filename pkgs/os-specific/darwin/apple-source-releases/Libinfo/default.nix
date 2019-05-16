{ appleDerivation }:

appleDerivation {
  installPhase = ''
    substituteInPlace xcodescripts/install_files.sh \
      --replace "/usr/local/" "/" \
      --replace "/usr/" "/" \
      --replace '-o "$INSTALL_OWNER" -g "$INSTALL_GROUP"' "" \
      --replace "ln -h" "ln -n"

    export DSTROOT=$out
    sh xcodescripts/install_files.sh
  '';
}
