{ stdenv, fetchFromGitHub }:

# On upgrade check https://github.com/fricy/Phoebus/blob/master/manifest.json
# for compatibility information.

stdenv.mkDerivation {
  name = "phoebus-theme-20160118";

  src = fetchFromGitHub {
    owner = "fricy";
    repo = "Phoebus";
    rev = "2c5777b0f307b1d752a8a484c6a05b67531c84a9";
    sha256 = "0a5ixm181wz7crr3rpa2mh0drb371j5hvizqninvdnhah2mypz8v";
  };

  installPhase = ''
    mkdir $out
    cp -r data raw $out
  '';

  passthru.dfVersion = "0.42.05";

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
