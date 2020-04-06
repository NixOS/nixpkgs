{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "4.2.3";
  pname = "randoop";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "0apmwbh761b02z8i4s3d270ms0c1fw98d10rpczngrs2jz37s2m9";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/lib $out/doc

    cp -R *.jar $out/lib
    cp README.txt $out/doc
  '';

  meta = with stdenv.lib; {
    description = "Automatic test generation for Java";
    homepage = "https://randoop.github.io/randoop/";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
