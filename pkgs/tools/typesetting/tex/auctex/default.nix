{ stdenv, fetchurl, emacs, texlive, ghostscript }:
 
let auctex = stdenv.mkDerivation ( rec {
  version = "12.3";

  # Make this a valid tex(live-new) package;
  # the pkgs attribute is provided with a hack below.
  pname = "auctex";
  tlType = "run";


  outputs = [ "out" "tex" ];

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1pd99hbhci3l1n0lmzn803svqwl47kld6172gwkwjmwlnqqgxm1g";
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
    homepage = "https://www.gnu.org/software/auctex";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl3;
  };
});

in auctex // { pkgs = [ auctex.tex ]; }
