{ lib, stdenv, fetchurl, perl, perlPackages }:

let
  pname = "stow";
  version = "2.3.1";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnu/stow/stow-${version}.tar.bz2";
    sha256 = "0bs2b90wjkk1camcasy8kn403kazq6c7fj5m5msfl3navbgwz9i6";
  };

  buildInputs = with perlPackages; [ perl IOStringy TestOutput ];

  doCheck = true;

  meta = with lib; {
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

    license = licenses.gpl3Plus;
    homepage = "https://www.gnu.org/software/stow/";
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.all;
  };
}
