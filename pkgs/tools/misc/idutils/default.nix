{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation rec {
  name = "idutils-4.2";
  src = fetchurl {
    url = "mirror://gnu/idutils/${name}.tar.gz";
    sha256 = "16gsy7vrjax2zl4galwq03l0y97d18p0pyd5cccyc4i8y3mhwx65";
  };

  buildInputs = [ emacs ];

  doCheck = true;

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
    license = "GPLv2+";
  };
}
