{ stdenv, fetchFromGitHub }:

# On upgrade check https://github.com/DFgraphics/CLA/blob/master/manifest.json
# for compatibility information.

stdenv.mkDerivation rec {
  name = "cla-theme-${version}";
  version = "43.05-v23";

  src = fetchFromGitHub {
    owner = "DFgraphics";
    repo = "CLA";
    rev = version;
    sha256 = "1i74lyz7mpfrvh5g7rajxldhw7zddc2kp8f6bgfr3hl5l8ym5ci9";
  };

  installPhase = ''
    mkdir $out
    cp -r data raw $out
  '';

  passthru.dfVersion = "0.43.05";

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "CLA graphics set for Dwarf Fortress";
    homepage = http://www.bay12forums.com/smf/index.php?topic=105376.0;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.free;
  };
}
