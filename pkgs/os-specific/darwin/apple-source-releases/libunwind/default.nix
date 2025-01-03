{ lib, appleDerivation }:

appleDerivation {
  dontBuild = true;

  # install headers only
  installPhase = ''
    mkdir -p $out/lib
    cp -R include $out/include
  '';

  meta = with lib; {
    maintainers = with maintainers; [ copumpkin lnl7 ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
