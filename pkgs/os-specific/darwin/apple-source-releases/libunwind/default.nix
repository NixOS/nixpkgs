{ lib, appleDerivation }:

appleDerivation {
  dontBuild = true;

  # install headers only
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -R include $out/include

    runHook postInstall
  '';

  meta = with lib; {
    maintainers = with maintainers; [ copumpkin lnl7 ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
