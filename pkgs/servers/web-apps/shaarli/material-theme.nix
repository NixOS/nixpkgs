{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "shaarli-material";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "kalvn";
    repo = "Shaarli-Material";
    rev = "v${version}";
    sha256 = "161kf7linyl2l2d7y60v96xz3fwa572fqm1vbm58mjgkzkfndhrv";
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
    homepage = https://github.com/kalvn/Shaarli-Material;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
