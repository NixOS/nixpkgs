{ stdenv, fetchurl, pcre }:

stdenv.mkDerivation rec {
  name = "swig-2.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/swig/${name}.tar.gz";
    sha256 = "12pcw4whi36vd41c43v8c62bn7vnq331hmvzsrg8wvyj61vi2fkn";
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

    maintainers = with stdenv.lib.maintainers; [ ludo urkud ];
  };
}
