{ stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  name = "swig-1.3.40";

  src = fetchurl {
    url = "mirror://sourceforge/swig/${name}.tar.gz";
    sha256 = "02dc8g8wy75nd2is1974rl24c6mdl0ai1vszs1xpg9nd7dlv6i8r";
  };

  #buildInputs = [ boost ]; # needed for `make check'

  /* The test suite fails this way:

      building python_cpp
      python: tpp.c:63: __pthread_tpp_change_priority: Assertion `new_prio == -1 || (new_prio >= __sched_fifo_min_prio && new_prio <= __sched_fifo_max_prio)' failed.
      /bin/sh: line 1: 32101 Aborted                 env LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH PYTHONPATH=.:$PYTHONPATH python ./li_boost_shared_ptr_runme.py
      make[1]: *** [li_boost_shared_ptr.cpptest] Error 134

     This may be an uninitialized mutex or mutexattr or something.
   */
  doCheck = false;

  meta = {
    description = "SWIG, an interface compiler that connects C/C++ code to higher-level languages";

    longDescription = ''
       SWIG is an interface compiler that connects programs written in C and
       C++ with languages such as Perl, Python, Ruby, Scheme, and Tcl.  It
       works by taking the declarations found in C/C++ header files and using
       them to generate the wrapper code that scripting languages need to
       access the underlying C/C++ code.  In addition, SWIG provides a variety
       of customization features that let you tailor the wrapping process to
       suit your application.
    '';

    homepage = http://swig.org/;

    # Licensing is a mess: http://www.swig.org/Release/LICENSE .
    license = "BSD-style";

    platforms = stdenv.lib.platforms.linux;

    maintainers = [ ];
  };
}
