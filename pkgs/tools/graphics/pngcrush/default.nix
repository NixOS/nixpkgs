{ stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  name = "pngcrush-1.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/pmt/${name}-nolib.tar.xz";
    sha256 = "1h3sibmmiq4ynvf8hrpksfrbcmszxh4bqpkqy5c0m8828c7drpr9";
  };

  makeFlags = [ "CC=cc" "LD=cc" ];      # gcc and/or clang compat

  configurePhase = ''
    sed -i s,/usr,$out, Makefile
  '';

  buildInputs = [ libpng ];

  meta = {
    homepage = http://pmt.sourceforge.net/pngcrush;
    description = "A PNG optimizer";
    license = stdenv.lib.licenses.free;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
