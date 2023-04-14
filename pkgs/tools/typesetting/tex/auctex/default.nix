{ lib, stdenv, fetchurl, emacs, texlive, ghostscript }:

let auctex = stdenv.mkDerivation ( rec {
  # Make this a valid tex(live-new) package;
  # the pkgs attribute is provided with a hack below.
  pname = "auctex";
  version = "12.3";
  tlType = "run";

  outputs = [ "out" "tex" ];

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-L9T+MLaUV8knf+IE0+g8hHK89QDI/kqBDXREBhdMqd0=";
  };

  buildInputs = [
    emacs
    ghostscript
    (texlive.combine { inherit (texlive) scheme-basic hypdoc;  })
  ];

  preConfigure = ''
    mkdir -p "$tex"
  '';

  configureFlags = [
    "--with-lispdir=\${out}/share/emacs/site-lisp"
    "--with-texmf-dir=\${tex}"
  ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/auctex";
    description = "Extensible package for writing and formatting TeX files in GNU Emacs and XEmacs";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
});

in auctex // { pkgs = [ auctex.tex ]; }
