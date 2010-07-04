{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation rec {
  name = "idutils-4.5";
  
  src = fetchurl {
    url = "mirror://gnu/idutils/${name}.tar.gz";
    sha256 = "0j92k2dwg381kx2z556v9162l16mfra3xqbfcjrkdd2fw5jsgn2q";
  };

  buildInputs = stdenv.lib.optional stdenv.isLinux emacs;

  doCheck = true;

  patches = [ ./nix-mapping.patch ];

  meta = {
    description = "GNU Idutils, a text searching utility";

    longDescription = ''
      An "ID database" is a binary file containing a list of file
      names, a list of tokens, and a sparse matrix indicating which
      tokens appear in which files.

      With this database and some tools to query it, many
      text-searching tasks become simpler and faster.  For example,
      you can list all files that reference a particular `\#include'
      file throughout a huge source hierarchy, search for all the
      memos containing references to a project, or automatically
      invoke an editor on all files containing references to some
      function or variable.  Anyone with a large software project to
      maintain, or a large set of text files to organize, can benefit
      from the ID utilities.

      Although the name `ID' is short for `identifier', the ID
      utilities handle more than just identifiers; they also treat
      other kinds of tokens, most notably numeric constants, and the
      contents of certain character strings.
    '';

    homepage = http://www.gnu.org/software/idutils/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
