{ stdenv, fetchurl, emacs, texLive }:
 
stdenv.mkDerivation ( rec {
  pname = "auctex";
  version = "11.87";
  name = "${pname}-${version}";

  meta = {
    description = "Extensible package for writing and formatting TeX files in GNU Emacs and XEmacs";
    homepage = http://www.gnu.org/software/auctex;
  };

  src = fetchurl {
    url = "mirror://gnu/${pname}/${name}.tar.gz";
    sha256 = "1wjwpmvhpj8q0zd78lj7vyzqhx4rbdhkflslylkzgnw5wllp5mb3";
  };

  buildInputs = [ emacs texLive ];

  configureFlags = [
    "--with-lispdir=\${out}/share/emacs/site-lisp"
    "--disable-preview"
  ];
})
