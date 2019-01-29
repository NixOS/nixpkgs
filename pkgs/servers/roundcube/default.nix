{ lib, stdenv, fetchzip, buildEnv, roundcube, roundcubePlugins }:
let
  version = "1.3.8";
in
fetchzip rec {
  name= "roundcube-${version}";

  url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
  sha256 = "1lhwr13bglm8rqgamnb480b07wpqhw9bskjj2xxb0x8kdjly29ks";

  extraPostFetch = ''
    ln -sf /etc/roundcube/config.inc.php $out/config/config.inc.php
    rm -rf $out/installer
  '';

  passthru.withPlugins = f: buildEnv {
    name = "${roundcube.name}-with-plugins";
    paths = (f roundcubePlugins) ++ [ roundcube ];
  };

  meta = {
    description = "Open Source Webmail Software";
    maintainers = with stdenv.lib.maintainers; [ vskilet ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
