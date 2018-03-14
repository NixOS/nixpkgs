{ pkgs ? import ../. {} }:
rec {
  test-lib = import ./lib { inherit pkgs; };

  callTest = pkgs.newScope test-lib;

  maxima = callTest ./maxima.nix {};
  libreoffice = callTest ./libreoffice.nix {};

  coreutils = callTest ./coreutils.nix {};
  coreutils-versions = coreutils.versions;
  coreutils-exit-codes = coreutils.exit-codes;

  pdflatex = callTest ./texlive/pdflatex.nix {};
  xelatex = callTest ./texlive/xelatex.nix {};

  imagemagick-pdf = callTest ./imagemagick/pdf.nix {};

  zathura = callTest ./zathura.nix {
    pdfTest = imagemagick-pdf;
  };
  evince = callTest ./evince.nix {
    pdfTest = imagemagick-pdf;
  };
}
