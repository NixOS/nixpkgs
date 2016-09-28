{ stdenv, fetchFromGitHub }:

# On upgrade check https://github.com/DFgraphics/Phoebus/blob/master/manifest.json
# for compatibility information.

stdenv.mkDerivation rec {
  name = "phoebus-theme-${version}";
  version = "43.03";

  src = fetchFromGitHub {
    owner = "DFgraphics";
    repo = "Phoebus";
    rev = version;
    sha256 = "1mga5w3mks3bm6qch7azffr51g3q26za7hnas4qmxfs3m56bjav7";
  };

  installPhase = ''
    mkdir $out
    cp -r data raw $out
  '';

  passthru.dfVersion = "0.43.05";

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
