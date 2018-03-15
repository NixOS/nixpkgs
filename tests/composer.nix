{ pkgs ? import ../. {} }:
let
  callPackage = pkgs.callPackage;
in
rec {
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
}
