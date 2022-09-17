{ lib, stdenv, fetchurl }:
stdenv.mkDerivation {
  pname = "jpegexiforient";
  version = "unstable-2002-02-17";
  src = fetchurl {
    url = "http://sylvana.net/jpegcrop/jpegexiforient.c";
    sha256 = "1v0f42cvs0397g9v46p294ldgxwbp285npg6npgnlnvapk6nzh5s";
  };
  unpackPhase = ''
    cp $src jpegexiforient.c
  '';
  buildPhase = ''
    $CC -o jpegexiforient jpegexiforient.c
  '';
  installPhase = ''
    install -Dt $out/bin jpegexiforient
  '';
  meta = with lib; {
    description = "Utility program to get and set the Exif Orientation Tag";
    homepage = "http://sylvana.net/jpegcrop/exif_orientation.html";
    # Website doesn't mention any license, but I think it's safe to assume this
    # to be free since it's from IJG, the current maintainers of libjpeg
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ infinisil ];
  };
}
