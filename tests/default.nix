{ pkgs ? import ../default.nix {} }:
with import ./composer.nix { inherit pkgs; };
{
  inherit
    maxima 
    libreoffice libreoffice-executables
    coreutils-versions coreutils-exit-codes
    pdflatex xelatex
    imagemagick-pdf
    zathura
    evince
    ;
}
