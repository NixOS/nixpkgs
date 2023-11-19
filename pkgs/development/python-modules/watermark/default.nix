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
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4/1Y7cdh1tF33jgPrqdxCGPcRnnxx+Wf8lyztF54Ck0=";
  };

  propagatedBuildInputs = [
    ipython
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs =  [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "watermark"
  ];

  meta = with lib; {
    description = "IPython extension for printing date and timestamps, version numbers, and hardware information";
    homepage = "https://github.com/rasbt/watermark";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nphilou ];
  };
}
