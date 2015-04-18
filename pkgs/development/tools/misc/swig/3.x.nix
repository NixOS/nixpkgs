{ stdenv, fetchurl, pcre }:

stdenv.mkDerivation rec {
  name = "swig-3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/swig/${name}.tar.gz";
    sha256 = "04vqrij3k6pcq41y7rzl5rmhnghqg905f11wyrqw7vdwr9brcrm2";
  };

  buildInputs = [ pcre ];

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

    maintainers = with stdenv.lib.maintainers; [ urkud ];
  };
}
