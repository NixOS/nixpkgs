{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "gperf-3.1";

  src = fetchurl {
    url = "mirror://gnu/gperf/${name}.tar.gz";
    sha256 = "1qispg6i508rq8pkajh26cznwimbnj06wq9sd85vg95v8nwld1aq";
  };

  meta = {
    description = "Perfect hash function generator";

    longDescription = ''
      GNU gperf is a perfect hash function generator.  For a given
      list of strings, it produces a hash function and hash table, in
      form of C or C++ code, for looking up a value depending on the
      input string.  The hash function is perfect, which means that
      the hash table has no collisions, and the hash table lookup
      needs a single string comparison only.

      GNU gperf is highly customizable.  There are options for
      generating C or C++ code, for emitting switch statements or
      nested ifs instead of a hash table, and for tuning the algorithm
      employed by gperf.
    '';

    license = lib.licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/gperf/";
    platforms = lib.platforms.unix;
  };
}
