{ stdenv, fetchurl, perl, perlPackages }:

stdenv.mkDerivation {
  name = "stow-2.2.0";

  src = fetchurl {
    url = mirror://gnu/stow/stow-2.2.0.tar.bz2;
    sha256 = "01bbsqjmrnd9925s3grvgjnrl52q4w65imrvzy05qaij3pz31g46";
  };

  buildInputs = [ perl perlPackages.TestOutput ];

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
    homepage = http://www.gnu.org/software/stow/;

    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = stdenv.lib.platforms.all;
  };
}
