{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "shaarli-material";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "kalvn";
    repo = "Shaarli-Material";
    rev = "v${version}";
    sha256 = "1lx2yqsl9j4gxfz9h5vfrwk17vf726snari08q55rz52qgpy9kcl";
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
    # This package has not been updated for the new build process
    # introduced in 0.10.3 which depends on npm and gulp.
    broken = true;
    description = "A theme base on Google's Material Design for Shaarli, the superfast delicious clone";
    license = licenses.mit;
    homepage = "https://github.com/kalvn/Shaarli-Material";
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
