{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shaarli-material-${version}";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "kalvn";
    repo = "Shaarli-Material";
    rev = "v${version}";
    sha256 = "1bxw74ksvfv46995iwc7jhvl78hd84lcq3h9iyxvs8gpkhkapv55";
  };

  patchPhase = ''
    for f in material/*.html
    do
      substituteInPlace $f \
        --replace '.min.css?v={$version_hash}"' '.min.css#"' \
        --replace '.min.js?v={$version_hash}"'  '.min.js#"' \
        --replace '.png"'     '.png#"'
    done
  '';

  installPhase = ''
    mv material/ $out
  '';

  meta = with stdenv.lib; {
    description = "A theme base on Google's Material Design for Shaarli, the superfast delicious clone";
    license = licenses.mit;
    homepage = https://github.com/kalvn/Shaarli-Material;
    maintainers = with maintainers; [ schneefux ];
    platforms = platforms.all;
  };
}
