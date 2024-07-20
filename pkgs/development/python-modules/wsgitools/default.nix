{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  setuptools,
  pyasyncore,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "wsgitools";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MTh2BwNTu7NsTHuvoH+r0YHjEGfphX84f04Ah2eu02A=";
  };

  build-system = [ setuptools ];

  # the built-in asyncore library was removed in python 3.12
  dependencies = lib.optionals (pythonAtLeast "3.12") [ pyasyncore ];

  pythonImportsCheck = [ "wsgitools" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    maintainers = with maintainers; [ clkamp ];
    description = "Set of tools working with WSGI";
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
