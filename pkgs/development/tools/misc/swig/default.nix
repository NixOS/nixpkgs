{ stdenv, fetchurl, boost, tcl }:

stdenv.mkDerivation rec {
  name = "swig-1.3.40";

  src = fetchurl {
    url = "mirror://sourceforge/swig/${name}.tar.gz";
    sha256 = "02dc8g8wy75nd2is1974rl24c6mdl0ai1vszs1xpg9nd7dlv6i8r";
  };

  doCheck = true;
  # 'make check' uses boost and tcl
  buildInputs = stdenv.lib.optionals doCheck [ boost tcl ];

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

    platforms = stdenv.lib.platforms.all;

    maintainers = [ ];
  };
}
