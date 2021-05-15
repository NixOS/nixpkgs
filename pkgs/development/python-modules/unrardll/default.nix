{ lib, buildPythonPackage, fetchPypi, unrar }:

buildPythonPackage rec {
  pname = "unrardll";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4149c0729cf96a0bae80360e7d94dc40af1088c8da7f6eb8d10e09b8632e92ad";
  };

  buildInputs = [ unrar ];

  pythonImportsCheck = [ "unrardll" ];

  meta = with lib; {
    description = "Wrap the Unrar DLL to enable unraring of files in python";
    homepage = "https://github.com/kovidgoyal/unrardll";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
