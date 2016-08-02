{ stdenv, fetchurl, emacs, texlive, ghostscript }:
 
let auctex = stdenv.mkDerivation ( rec {
  version = "11.89";
  name = "${pname}-${version}";

  # Make this a valid tex(live-new) package;
  # the pkgs attribute is provided with a hack below.
  pname = "auctex";
  tlType = "run";


  outputs = [ "out" "tex" ];

  src = fetchurl {
    url = "mirror://gnu/${pname}/${name}.tar.gz";
    sha256 = "1cf9fkkmzjxa4jvk6c01zgxdikr4zzb5pcx8i4r0hwdk0xljkbwq";
  };

  buildInputs = [ emacs texlive.combined.scheme-basic ghostscript ];

  preConfigure = ''
    mkdir -p "$tex"
  '';

  configureFlags = [
    "--with-lispdir=\${out}/share/emacs/site-lisp"
    "--with-texmf-dir=\${tex}"
  ];

  meta = {
    description = "Extensible package for writing and formatting TeX files in GNU Emacs and XEmacs";
    homepage = http://www.gnu.org/software/auctex;
    platforms = stdenv.lib.platforms.unix;
  };
});

in auctex // { pkgs = [ auctex.tex ]; }
