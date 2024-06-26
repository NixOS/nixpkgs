{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "gperf";
  version = "3.0.4";

  src = fetchurl {
    url = "mirror://gnu/gperf/gperf-${version}.tar.gz";
    sha256 = "0gnnm8iqcl52m8iha3sxrzrl9mcyhg7lfrhhqgdn4zj00ji14wbn";
  };

  nativeBuildInputs = [ autoreconfHook ];
  patches = [
    ./gperf-ar-fix.patch
    # Clang 16 defaults to C++17, which does not allow `register` as a storage class specifier.
    ./gperf-c++17-register-fix.patch
  ];

  # Replace the conditional inclusion of `string.h` on VMS with unconditional inclusion on all
  # platforms. Otherwise, clang 16 fails to build gperf due to use of undeclared library functions.
  postPatch = ''
    sed '/#ifdef VMS/{N;N;N;N;N;s/.*/#include <string.h>/}' -i lib/getopt.c
  '';

  meta = {
    description = "Perfect hash function generator";
    mainProgram = "gperf";

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
