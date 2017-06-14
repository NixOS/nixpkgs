{ stdenv, cctools, appleDerivation }:

appleDerivation {
  buildInputs = [ cctools ];

  postPatch = ''
    substituteInPlace makefile \
      --replace /usr/bin/ "" \
      --replace '$(ISYSROOT)' "" \
      --replace 'shell xcodebuild -version -sdk' 'shell true' \
      --replace 'shell xcrun -sdk $(SDKPATH) -find' 'shell echo' \
      --replace '-install_name $(libdir)' "-install_name $out/lib/" \
      --replace /usr/local/bin/ /bin/ \
      --replace /usr/lib/ /lib/ \
  '';

  makeFlags = [ "DSTROOT=$(out)" ];

  postInstall = ''
    mv $out/usr/local/include $out/include
  '';
}
