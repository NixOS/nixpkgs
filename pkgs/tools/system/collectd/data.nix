{ stdenv, collectd }:

stdenv.mkDerivation {
  pname = "collectd-data";
  inherit (collectd) meta src version;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/collectd/ src/*.{db,conf}

    runHook postInstall
  '';
}
