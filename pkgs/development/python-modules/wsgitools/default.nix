{lib
,buildPythonPackage
,fetchPypi
}:

buildPythonPackage rec {
  pname = "wsgitools";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q6kmrkqf02fgww7z1g9cw8f70fimdzs1bvv9inb7fsk0c3pcf1i";
  };

  meta = with lib; {
    maintainers = with maintainers; [ clkamp ];
    description = "A set of tools working with WSGI";
    longDescription = ''
      wsgitools is a set of tools working with WSGI (see PEP 333). It
      includes classes for filtering content, middlewares for caching,
      logging and tracebacks as well as two backends for SCGI. Goals
      in writing it were portability and simplicity.
    '';
    homepage = "https://subdivi.de/~helmut/wsgitools/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
