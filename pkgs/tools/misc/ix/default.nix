{ lib, resholve, fetchurl, runtimeShell, curl }:

resholve.mkDerivation {
  pname = "ix";
  version = "20190815";

  src = fetchurl {
    url = "http://ix.io/client";
    hash = "sha256-p/j/Nz7tzLJV7HgUwVsiwN1WxCx4Por+HyRgFTTRgnU=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 $src $out/bin/ix

    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/ix" ];
    interpreter = runtimeShell;
    inputs = [ curl ];
    keep."$echo" = true;
  };

  meta = with lib; {
    homepage = "http://ix.io";
    description = "Command line pastebin";
    maintainers = with maintainers; [ asymmetric ];
    platforms = platforms.all;
  };
}
