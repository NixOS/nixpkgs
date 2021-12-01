{ lib
, buildPythonPackage
, construct
, fetchFromGitHub
, isPy3k
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "snapcast";
  version = "2.1.3";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "happyleavesaoc";
    repo = "python-snapcast";
    rev = version;
    sha256 = "1jigdccdd7bffszim942mxcwxyznfjx7y3r5yklz3psl7zgbzd6c";
  };

  propagatedBuildInputs = [
    construct
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "snapcast" ];

  meta = with lib; {
    description = "Control Snapcast, a multi-room synchronous audio solution";
    homepage = "https://github.com/happyleavesaoc/python-snapcast/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
