{ stdenv, fetchFromGitHub }:

# On upgrade check https://github.com/DFgraphics/Phoebus/blob/master/manifest.json
# for compatibility information.

stdenv.mkDerivation rec {
  name = "phoebus-theme-${version}";
  version = "44.03";

  src = fetchFromGitHub {
    owner = "DFgraphics";
    repo = "Phoebus";
    rev = version;
    sha256 = "0jpklikg2bf315m45kdkhd1n1plzb4jwzsg631gqfm9dwnrcs4w3";
  };

  installPhase = ''
    mkdir $out
    cp -r data raw $out
  '';

  passthru.dfVersion = "0.44.03";

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "Phoebus graphics set for Dwarf Fortress";
    homepage = http://www.bay12forums.com/smf/index.php?topic=137096.0;
    platforms = platforms.all;
    maintainers = with maintainers; [ a1russell abbradar ];
    # https://github.com/fricy/Phoebus/issues/5
    license = licenses.free;
  };
}
