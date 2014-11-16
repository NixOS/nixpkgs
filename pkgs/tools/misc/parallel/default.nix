{ fetchurl, stdenv, perl }:

stdenv.mkDerivation rec {
  name = "parallel-20141022";

  src = fetchurl {
    url = "mirror://gnu/parallel/${name}.tar.bz2";
    sha256 = "1dpssybids6k6na4rh2gwv1m581h28rcmsvq0hs56hrrh7qpjmvp";
  };

  patchPhase =
    '' sed -i "src/parallel" -e's|/usr/bin/perl|${perl}/bin/perl|g'
    '';

  preBuild =
    # The `sem' program wants to write to `~/.parallel'.
    '' export HOME="$PWD"
    '';

  buildInputs = [ perl ];
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
