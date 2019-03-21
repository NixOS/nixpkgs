{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, pcre }:

stdenv.mkDerivation rec {
  name = "swig-${version}";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-${version}";
    sha256 = "0khm9gh5pczfcihr0pbicaicc4v9kjm5ip2alvkhmbb3ga6njkcm";
  };

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ pcre ];

  configureFlags = [ "--without-tcl" ];

  postPatch = ''
    # Disable ccache documentation as it need yodl
    sed -i '/man1/d' CCache/Makefile.in
  '';

  preConfigure = ''
    ./autogen.sh
  '';

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

    platforms = lib.platforms.linux ++ lib.platforms.darwin;

    maintainers = [ ];
  };
}
