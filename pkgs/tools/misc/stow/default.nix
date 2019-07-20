{ stdenv, fetchurl, perl, perlPackages, makeWrapper }:

let
  pname = "stow";
  version = "2.3.0";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnu/stow/stow-${version}.tar.bz2";
    sha256 = "1fnn83wwx3yaxpqkq8xyya3aiibz19fwrfj30nsiikm7igmwgiv5";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with perlPackages; [ perl IOStringy TestOutput HashMerge Clone CloneChoose ];

  postFixup = ''
    wrapProgram "$out"/bin/stow \
    --set PERL5LIB "$out/lib/perl5/site_perl:${with perlPackages; makePerlPath [
      HashMerge Clone CloneChoose
    ]}"
  '';

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

    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = stdenv.lib.platforms.all;
  };
}
