{ stdenv, fetchFromGitHub, fetchpatch, ... }: stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-fever-api";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "DigitalDJ";
    repo = "tinytinyrss-fever-plugin";
    rev = version;
    sha256 = "000ys6r6a90x1v6fjyb86b0aab6j7g2d29w8d5sccyv895m4x8r1";
  };

  installPhase = ''
    mkdir -p $out/fever
    cp *.php $out/fever
  '';

  meta = with stdenv.lib; {
    description = "TT-RSS Fever API Plugin";
    license = licenses.gpl3;
    homepage = "https://github.com/DigitalDJ/tinytinyrss-fever-plugin";
    platforms = platforms.all;
    maintainers = with maintainers; [ ajs124 das_j ];
  };
}
