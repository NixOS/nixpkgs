{ lib, stdenv, fetchurl }:

stdenv.mkDerivation (finalAttrs: {
  pname = "trunk-io";
  version = "1.3.0";

  src = fetchurl {
    url = "https://trunk.io/releases/launcher/${finalAttrs.version}/trunk";
    hash = "sha256-v9WJb9oIs5k2ZIX80L83dRtEarTiVsXBtXBta0sP++A=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D $src $out/bin/trunk
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://trunk.io/";
    description = "Developer experience toolkit used to check, test, merge, and monitor code";
    license = licenses.unfree;
    maintainers = with maintainers; [ aaronjheng ];
  };
})
