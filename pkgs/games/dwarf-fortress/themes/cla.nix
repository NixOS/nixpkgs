{ stdenv, fetchFromGitHub }:

# On upgrade check https://github.com/DFgraphics/CLA/blob/master/manifest.json
# for compatibility information.

stdenv.mkDerivation rec {
  name = "cla-theme-${version}";
  version = "44.01-v24";

  src = fetchFromGitHub {
    owner = "DFgraphics";
    repo = "CLA";
    rev = version;
    sha256 = "1lyazrls2vr8z58vfk5nvaffyv048j5xkr4wjvp6vrqxxvrxyrfd";
  };

  installPhase = ''
    mkdir $out
    cp -r data raw $out
  '';

  passthru.dfVersion = "0.44.02";

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "CLA graphics set for Dwarf Fortress";
    homepage = http://www.bay12forums.com/smf/index.php?topic=105376.0;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.free;
  };
}
