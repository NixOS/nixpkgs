{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shaarli-material-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "kalvn";
    repo = "Shaarli-Material";
    rev = "v${version}";
    sha256 = "1gam080iwr8vd6k6liv0zmpb3zyw37a53nj1s4ywb4d2i68hjncd";
  };

  patchPhase = ''
    for f in material/*.html
    do
      substituteInPlace $f \
        --replace '.min.css"' '.min.css#"' \
        --replace '.min.js"'  '.min.js#"' \
        --replace '.png"'     '.png#"'
    done

    substituteInPlace material/loginform.html \
        --replace '"ban_canLogin()"' '"ban_canLogin($conf)"' # PHP 7.1 fix (https://github.com/shaarli/Shaarli/issues/711)
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
