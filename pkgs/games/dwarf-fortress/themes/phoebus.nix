{ stdenv, fetchFromGitHub }:

# On upgrade check https://github.com/DFgraphics/Phoebus/blob/master/manifest.json
# for compatibility information.

stdenv.mkDerivation {
  name = "phoebus-theme-20160128";

  src = fetchFromGitHub {
    owner = "DFgraphics";
    repo = "Phoebus";
    rev = "52b19b69c7323f9002ad195ecd68ac02ff0099a2";
    sha256 = "1pw5l5v7l1bvxzjf4fivmagpmghffvz0wlws2ksc7d5vy48ybcmg";
  };

  installPhase = ''
    mkdir $out
    cp -r data raw $out
  '';

  passthru.dfVersion = "0.42.06";

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "Phoebus graphics set for Dwarf Fortress";
    homepage = "http://www.bay12forums.com/smf/index.php?topic=137096.0";
    platforms = platforms.all;
    maintainers = with maintainers; [ a1russell abbradar ];
    # https://github.com/fricy/Phoebus/issues/5
    license = licenses.free;
  };
}
