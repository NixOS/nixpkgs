{ lib, auctex }:
lib.overrideDerivation auctex (x: {
  preConfigure = ''
    mkdir -p $out/texmf-dist
  '';
  configureFlags = [
    "--with-lispdir=\${out}/share/emacs/site-lisp"
    "--with-texmf-dir=\${out}/texmf-dist"
  ];
  postInstall = ''
    ln -s $out/share/info $out/
  '';
})
