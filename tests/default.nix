# This is the file to import to get external access to the tests
#
# The only current promise is that it is a function with defaults for all the
# arguments that returns a nested attrset with tests in the leaves. Each test
# is a derivation. Derivation `meta` is used in the same way as in normal
# packages; please add at least meta.description.
#
# The tests can still be renamed, please be ready for that
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
    youtube-dl
    view-pdf
    ;
}
