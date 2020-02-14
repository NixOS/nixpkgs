{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "4.2.1";
  pname = "randoop";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "0sq6zyagb8qrj629rq7amzi0dnm6q00mll6gd5yx1nqdnjbfb4qd";
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
