{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation rec {
  name = "idutils-4.6";

  src = fetchurl {
    url = "mirror://gnu/idutils/${name}.tar.xz";
    sha256 = "1hmai3422iaqnp34kkzxdnywl7n7pvlxp11vrw66ybxn9wxg90c1";
  };

  preConfigure =
    ''
       # Fix for building on Glibc 2.16.  Won't be needed once the
       # gnulib in idutils is updated.
       sed -i '/gets is a security hole/d' lib/stdio.in.h
    '';

  buildInputs = stdenv.lib.optional stdenv.isLinux emacs;

  doCheck = !stdenv.isDarwin;

  patches = [ ./nix-mapping.patch ];

  meta = {
    description = "Text searching utility";

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
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
