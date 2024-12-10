{
  lib,
  appleDerivation',
  stdenvNoCC,
}:

appleDerivation' stdenvNoCC {
  installPhase = ''
    mkdir -p $out/lib $out/include
    ln -s /usr/lib/dyld $out/lib/dyld
    cp -r include $out/
  '';

  meta = with lib; {
    description = "Impure primitive symlinks to the Mac OS native dyld, along with headers";
    maintainers = with maintainers; [ copumpkin ];
    platforms = platforms.darwin;
    license = licenses.apple-psl20;
  };
}
