{ stdenv, fetchurl, emacs, tetex }:
 
stdenv.mkDerivation {
  name = "auctex-11.84";
  meta = {
    description = "AUCTeX is an extensible package for writing and formatting TeX files in GNU Emacs and XEmacs.";
    homepage = http://www.gnu.org/software/auctex;
  };
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/auctex/auctex-11.84.tar.gz;
    md5 = "73970c51221524442c11cde13d0584e9";
  };
  configureFlags="--with-lispdir=\${out}/emacs/site-lisp --disable-preview";
  buildInputs = [ emacs tetex ];
}
