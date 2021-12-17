{ lib
, fetchFromGitHub
, buildPythonPackage
, importlib-metadata
, ipython
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "watermark";
  version = "2.2.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = pname;
    rev = "d3553b68dd30ac5b0951a6fae6083236e4c7f3bd";
    sha256 = "0w2mzi344x1mrv8d9jca67bhig34jissr9sqrk68gpg5n10alblb";
  };

  propagatedBuildInputs = [
    ipython
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  checkInputs =  [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "watermark" ];

  meta = with lib; {
    description = "IPython extension for printing date and time stamps, version numbers, and hardware information.";
    homepage = "https://github.com/rasbt/watermark";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nphilou ];
  };
}
