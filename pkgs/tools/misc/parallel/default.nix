{ fetchurl, stdenv, perl, makeWrapper, procps }:

stdenv.mkDerivation rec {
  name = "parallel-20150822";

  src = fetchurl {
    url = "mirror://gnu/parallel/${name}.tar.bz2";
    sha256 = "1ij7bjxhk2866mzh0v0v2m629b6d39r5ivwdzmh72s471m9hg45d";
  };

  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    sed -i 's,#![ ]*/usr/bin/env[ ]*perl,#!${perl}/bin/perl,' $out/bin/*

    wrapProgram $out/bin/parallel \
      --prefix PATH : "${procps}/bin" \
      --prefix PATH : "${perl}/bin" \
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Shell tool for executing jobs in parallel";
    longDescription =
      '' GNU Parallel is a shell tool for executing jobs in parallel.  A job
         is typically a single command or a small script that has to be run
         for each of the lines in the input.  The typical input is a list of
         files, a list of hosts, a list of users, or a list of tables.

         If you use xargs today you will find GNU Parallel very easy to use.
         If you write loops in shell, you will find GNU Parallel may be able
         to replace most of the loops and make them run faster by running
         jobs in parallel.  If you use ppss or pexec you will find GNU
         Parallel will often make the command easier to read.

         GNU Parallel makes sure output from the commands is the same output
         as you would get had you run the commands sequentially.  This makes
         it possible to use output from GNU Parallel as input for other
         programs.
      '';
    homepage = http://www.gnu.org/software/parallel/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
