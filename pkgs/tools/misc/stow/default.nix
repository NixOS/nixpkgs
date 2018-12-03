{ stdenv, fetchurl, perl, perlPackages }:

let
  version = "2.2.2";
in
stdenv.mkDerivation {
  name = "stow-${version}";

  src = fetchurl {
    url = "mirror://gnu/stow/stow-${version}.tar.bz2";
    sha256 = "1zd6g9cm3whvy5f87j81j4npl7q6kxl25f7z7p9ahiqfjqs200m0";
  };

  buildInputs = with perlPackages; [ perl IOStringy TestOutput ];

  doCheck = true;

  meta = {
    description = "A tool for managing the installation of multiple software packages in the same run-time directory tree";

    longDescription = ''
      GNU Stow is a symlink farm manager which takes distinct packages
      of software and/or data located in separate directories on the
      filesystem, and makes them appear to be installed in the same
      place. For example, /usr/local/bin could contain symlinks to
      files within /usr/local/stow/emacs/bin, /usr/local/stow/perl/bin
      etc., and likewise recursively for any other subdirectories such
      as .../share, .../man, and so on.
    '';

    license = stdenv.lib.licenses.gpl3Plus;
    homepage = https://www.gnu.org/software/stow/;

    maintainers = with stdenv.lib.maintainers; [ the-kenny jgeerds ];
    platforms = stdenv.lib.platforms.all;
  };
}
