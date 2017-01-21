{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shaarli-material-${version}";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "kalvn";
    repo = "Shaarli-Material";
    rev = "v${version}";
    sha256 = "0ivq35183r5vyzvf47sgxwdxllmvhd5w9w75xgyp3kbw2na4yrmr";
  };

  patchPhase = ''
    for f in material/*.html
    do
      substituteInPlace $f \
        --replace '.min.css"' '.min.css#"' \
        --replace '.min.js"'  '.min.js#"' \
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
