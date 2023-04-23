{
  stdenv,
  lib,
  fetchzip,
  dataDir ? "/var/lib/baikal/",
  configDir ? "/etc/baikal/",
}:
stdenv.mkDerivation rec {
  pname = "baikal";
  version = "0.9.3";

  src = fetchzip {
    url = "https://github.com/sabre-io/Baikal/releases/download/${version}/baikal-${version}.zip";
    hash = "sha256-MHzLOOH0X0xjLTZrrxLTsR6Tp7Veqrv+OrFzj18MxJE=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -R * $out/
    rm -rf $out/Specific
    ln -s ${dataDir} $out/Specific
    rm -rf $out/config
    ln -s ${configDir} $out/config

    sed -i '/$this->server =/a \        include "${configDir}/plugins.php";' $out/Core/Frameworks/Baikal/Core/Server.php
  '';

  meta = with lib; {
    homepage = "https://sabre.io/baikal/";
    description = "Baïkal is a lightweight CalDAV+CardDAV server";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
