{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trunk-io";
  version = "1.3.1";

  src = fetchurl {
    url = "https://trunk.io/releases/launcher/${finalAttrs.version}/trunk";
    hash = "sha256-kiUcc7RFPo7UWzEe2aQ2nrbI3GZ/zfxOlOdWw7YFoAs=";
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
