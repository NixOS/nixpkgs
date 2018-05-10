{ stdenv, fetchFromGitHub }:

# On upgrade check https://github.com/DFgraphics/CLA/blob/master/manifest.json
# for compatibility information.

stdenv.mkDerivation rec {
  name = "cla-theme-${version}";
  version = "44.xx-v25";

  src = fetchFromGitHub {
    owner = "DFgraphics";
    repo = "CLA";
    rev = version;
    sha256 = "1h8nwa939qzqklbi8vwsq9p2brvv7sc0pbzzrdjnb221lr9p58zk";
  };

  installPhase = ''
    mkdir $out
    cp -r data raw $out
  '';

  passthru.dfVersion = "0.44.09";

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "CLA graphics set for Dwarf Fortress";
    homepage = http://www.bay12forums.com/smf/index.php?topic=105376.0;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.free;
  };
}
