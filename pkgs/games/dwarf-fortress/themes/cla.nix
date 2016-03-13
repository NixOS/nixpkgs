{ stdenv, fetchFromGitHub }:

# On upgrade check https://github.com/DFgraphics/CLA/blob/master/manifest.json
# for compatibility information.

stdenv.mkDerivation {
  name = "cla-theme-20160128";

  src = fetchFromGitHub {
    owner = "DFgraphics";
    repo = "CLA";
    rev = "94088b778ed6f91cbddcd3e33aa1e5efa67f3101";
    sha256 = "0rx1375x9s791k9wzvj7sxcrv4xaggibxymzirayznvavr7zcsv1";
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
