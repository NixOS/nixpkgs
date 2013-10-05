{ stdenv, fetchurl, emacs, texLive }:
 
stdenv.mkDerivation ( rec {
  pname = "auctex";
  version = "11.85";
  name = "${pname}-${version}";

  meta = {
    description = "Extensible package for writing and formatting TeX files in GNU Emacs and XEmacs";
    homepage = http://www.gnu.org/software/auctex;
  };

  src = fetchurl {
    url = "mirror://gnu/${pname}/${name}.tar.gz";
    sha256 = "aebbea00431f8fd1e6be6519d9cc28e974942000737f956027da2c952a6d304e";
  };

  buildInputs = [ emacs texLive ];

  configureFlags = [
    "--with-lispdir=\${out}/share/emacs/site-lisp"
    "--disable-preview"
  ];
})
