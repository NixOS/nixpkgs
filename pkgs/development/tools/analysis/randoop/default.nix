{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "3.1.5";
  name = "randoop-${version}";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${version}/${name}.zip";
    sha256 = "13zspyi9fgnqc90qfqqnj0hb7869l0aixv0vwgj8m4m1hggpadlx";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/lib $out/doc

    cp -R *.jar $out/lib
    cp README.txt $out/doc
  '';

  meta = with stdenv.lib; {
    description = "Automatic test generation for Java";
    homepage = https://randoop.github.io/randoop/;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
