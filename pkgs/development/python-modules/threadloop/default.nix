{
  buildPythonPackage,
  fetchPypi,
  lib,
  tornado,
}:

buildPythonPackage rec {
  pname = "threadloop";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ixgKrDEBPeE8KtXINIGXcZktNQJnvduFRhOud+9XGUQ=";
  };

  propagatedBuildInputs = [ tornado ];

  doCheck = false; # ImportError: cannot import name 'ThreadLoop' from 'threadloop'

  pythonImportsCheck = [ "threadloop" ];

  meta = with lib; {
    description = "Library to run tornado coroutines from synchronous Python";
    homepage = "https://github.com/GoodPete/threadloop";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
