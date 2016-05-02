{ stdenv, fetchFromGitHub }:

# On upgrade check https://github.com/DFgraphics/CLA/blob/master/manifest.json
# for compatibility information.

stdenv.mkDerivation rec {
  name = "cla-theme-${version}";
  version = "42.06-v22";

  src = fetchFromGitHub {
    owner = "DFgraphics";
    repo = "CLA";
    rev = version;
    sha256 = "1rr52j1wns17axc27fab0wn0338axzwkqp7cpa690kb3bl1y0pf5";
  };

  installPhase = ''
    mkdir $out
    cp -r data raw $out
  '';

  passthru.dfVersion = "0.42.06";

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "CLA graphics set for Dwarf Fortress";
    homepage = "http://www.bay12forums.com/smf/index.php?topic=105376.0";
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.free;
  };
}
