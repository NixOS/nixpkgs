{ stdenv, collectd }:

stdenv.mkDerivation {
  inherit (collectd) meta version;

  pname = "collectd-data";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/collectd
    cp ${collectd}/share/collectd/*.{db,conf} $out/share/collectd/
  '';
}
