{ stdenv, fetchurl, emacs, texLive }:
 
stdenv.mkDerivation ( rec {
  pname = "auctex";
  version = "11.88";
  name = "${pname}-${version}";

  meta = {
    description = "Extensible package for writing and formatting TeX files in GNU Emacs and XEmacs";
    homepage = http://www.gnu.org/software/auctex;
  };

  src = fetchurl {
    url = "mirror://gnu/${pname}/${name}.tar.gz";
    sha256 = "0gy89nzha20p6m7kpv2nl1fnsfka9scc3mw1lz66fp6czganfs3i";
  };

  buildInputs = [ emacs texLive ];

  configureFlags = [
    "--with-lispdir=\${out}/share/emacs/site-lisp"
    "--disable-preview"
  ];
})
