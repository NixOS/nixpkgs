{ stdenv, fetchurl, xz, libsigsegv, readline, interactive ? false
, locale ? null }:

let
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = "gawk-4.1.4";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.xz";
    sha256 = "0rn2mmjxm767zliqzd67j7h2ncjn4j0321c60y9fy3grs3i89qak";
  };

  # When we do build separate interactive version, it makes sense to always include man.
  outputs = [ "out" "info" ] ++ stdenv.lib.optional (!interactive) "man";

  # FIXME: 4.1.4 testsuite breaks when only C locales are available
  doCheck = false /*!(
       stdenv.isCygwin # XXX: `test-dup2' segfaults on Cygwin 6.1
    || stdenv.isDarwin # XXX: `locale' segfaults
    || stdenv.isSunOS  # XXX: `_backsmalls1' fails, locale stuff?
    || stdenv.isFreeBSD
  )*/;

  nativeBuildInputs = [ xz.bin ];
  buildInputs =
       stdenv.lib.optional (stdenv.system != "x86_64-cygwin") libsigsegv
    ++ stdenv.lib.optional interactive readline
    ++ stdenv.lib.optional stdenv.isDarwin locale;

  configureFlags = stdenv.lib.optional (stdenv.system != "x86_64-cygwin") "--with-libsigsegv-prefix=${libsigsegv}"
    ++ [(if interactive then "--with-readline=${readline.dev}" else "--without-readline")];

  postInstall =
    if interactive then
      ''
        rm "$out"/bin/gawk-*
        ln -s gawk.1 "''${!outputMan}"/share/man/man1/awk.1
      ''
    else # TODO: remove this other branch on a stdenv rebuild
      ''
        rm $out/bin/gawk-*
        ln -s $man/share/man/man1/gawk.1 $man/share/man/man1/awk.1
      '';

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/gawk/;
    description = "GNU implementation of the Awk programming language";

    longDescription = ''
      Many computer users need to manipulate text files: extract and then
      operate on data from parts of certain lines while discarding the rest,
      make changes in various text files wherever certain patterns appear,
      and so on.  To write a program to do these things in a language such as
      C or Pascal is a time-consuming inconvenience that may take many lines
      of code.  The job is easy with awk, especially the GNU implementation:
      Gawk.

      The awk utility interprets a special-purpose programming language that
      makes it possible to handle many data-reformatting jobs with just a few
      lines of code.
    '';

    license = licenses.gpl3Plus;

    platforms = platforms.unix;

    maintainers = [ ];
  };
}

