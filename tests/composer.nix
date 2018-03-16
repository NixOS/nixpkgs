{ pkgs ? import ../. {} }:
let
  callPackage = pkgs.callPackage;
in
pkgs.lib.makeExtensible (self: with self; {
  maxima = callPackage ./maxima.nix {};
  libreoffice = callPackage ./libreoffice.nix {
    
  };
  libreoffice-executables = import ./temporary-helpers/check-executables.nix {
    package = pkgs.libreoffice;
  };

  coreutils = callPackage ./coreutils.nix {};
  coreutils-versions = coreutils.versions;
  coreutils-exit-codes = coreutils.exit-codes;

  pdflatex = callPackage ./texlive/texlive.nix { texCommand = "pdflatex"; };
  xelatex = callPackage ./texlive/texlive.nix { texCommand = "xelatex"; };

  imagemagick-pdf = callPackage ./imagemagick/pdf.nix {};

  zathura = callPackage ./zathura.nix {
    pdfTest = imagemagick-pdf;
  };
  evince = callPackage ./evince.nix {
    pdfTest = imagemagick-pdf;
  };

  view-pdf = pkgs.lib.genAttrs ["pdflatex" "xelatex" "imagemagick-pdf"]
    (generator: pkgs.lib.genAttrs ["zathura" "evince"]
       (viewer: self.${viewer}.override { pdfTest = self.${generator}; }));

  youtube-dl = callPackage ./youtube-dl/default.nix {};
})
