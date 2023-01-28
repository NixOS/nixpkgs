{ fetchurl, lib, stdenv, emacs, gnulib, autoconf, bison, automake, gettext, gperf, texinfo, perl, rsync}:

stdenv.mkDerivation rec {
  pname = "idutils";
  version = "4.6";

  src = fetchurl {
    url = "mirror://gnu/idutils/idutils-${version}.tar.xz";
    sha256 = "1hmai3422iaqnp34kkzxdnywl7n7pvlxp11vrw66ybxn9wxg90c1";
  };

  preConfigure = ''
    # replace embedded gnulib tests with those from gnulib package
    bash -O extglob -c "cd gnulib-tests; rm -r !(Makefile.am)"
    substituteInPlace ./configure.ac --replace "AC_PREREQ(2.61)" "AC_PREREQ(2.64)"
    ./bootstrap --force --gnulib-srcdir=${gnulib} --skip-po --bootstrap-sync --no-git
    '';

  buildInputs = lib.optional stdenv.isLinux emacs;
  nativeBuildInputs = [ gnulib autoconf bison automake gettext gperf texinfo perl rsync ];

  doCheck = !stdenv.isDarwin;

  patches = [ ./nix-mapping.patch ];

  meta = with lib; {
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

    homepage = "https://www.gnu.org/software/idutils/";
    license = licenses.gpl3Plus;

    maintainers = with maintainers; [ gfrascadorio ];
    platforms = lib.platforms.all;
  };
}
