{ stdenv, fetchurl, emacs, texLive }:
 
stdenv.mkDerivation ( rec {
  pname = "auctex";
  version = "11.89";
  name = "${pname}-${version}";

  meta = {
    description = "Extensible package for writing and formatting TeX files in GNU Emacs and XEmacs";
    homepage = http://www.gnu.org/software/auctex;
  };

  src = fetchurl {
    url = "mirror://gnu/${pname}/${name}.tar.gz";
    sha256 = "1cf9fkkmzjxa4jvk6c01zgxdikr4zzb5pcx8i4r0hwdk0xljkbwq";
  };

  buildInputs = [ emacs texLive ];

  configureFlags = [
    "--with-lispdir=\${out}/share/emacs/site-lisp"
    "--disable-preview"
  ];
})
