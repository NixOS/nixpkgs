{ lib
, stdenv
, fetchurl
, perlPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stow";
  version = "2.4.0";

  src = fetchurl {
    url = "mirror://gnu/stow/stow-${finalAttrs.version}.tar.bz2";
    hash = "sha256-p7rGc9qiRs9U/7SKET6t0gSmFWMOdrU7X2TYGidbd7M=";
  };

  nativeBuildInputs = [ perlPackages.perl ];
  buildInputs = with perlPackages; [ perl IOStringy TestOutput ];

  doCheck = true;

  meta = with lib; {
    description = "Tool for managing the installation of multiple software packages in the same run-time directory tree";

    longDescription = ''
      GNU Stow is a symlink farm manager which takes distinct packages
      of software and/or data located in separate directories on the
      filesystem, and makes them appear to be installed in the same
      place. For example, /usr/local/bin could contain symlinks to
      files within /usr/local/stow/emacs/bin, /usr/local/stow/perl/bin
      etc., and likewise recursively for any other subdirectories such
      as .../share, .../man, and so on.
    '';

    license = licenses.gpl3Plus;
    homepage = "https://www.gnu.org/software/stow/";
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.all;
  };
})
