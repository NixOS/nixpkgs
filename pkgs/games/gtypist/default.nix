{stdenv, fetchurl, makeWrapper, libiconv, ncurses, perl, fortune}:

stdenv.mkDerivation rec {
  name = "gtypist-${version}";
  version = "2.9.5";

  src = fetchurl {
    url = "mirror://gnu/gtypist/gtypist-${version}.tar.xz";
    sha256 = "0xzrkkmj0b1dw3yr0m9hml2y634cc4h61im6zwcq57s7285z8fn1";
  };

  buildInputs = [ makeWrapper ncurses perl fortune ]
   ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  preFixup = ''
     wrapProgram "$out/bin/typefortune" \
       --prefix PATH : "${fortune}/bin" \
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/gtypist;
    description = "Universal typing tutor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
