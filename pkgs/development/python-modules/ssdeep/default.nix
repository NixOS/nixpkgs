{ lib
, buildPythonPackage
, cffi
, fetchFromGitHub
, pytestCheckHook
, six
, ssdeep
}:

buildPythonPackage rec {
  pname = "ssdeep";
  version = "3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "DinoTools";
    repo = "python-ssdeep";
    rev = version;
    hash = "sha256-eAB4/HmPGj/ngHrqkOlY/kTdY5iUEBHxrsRYjR/RNyw=";
  };

  buildInputs = [
    ssdeep
  ];

  propagatedBuildInputs = [
    cffi
    six
  ];


  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  pythonImportsCheck = [
    "ssdeep"
  ];

  meta = with lib; {
    description = "Python wrapper for the ssdeep library";
    homepage = "https://github.com/DinoTools/python-ssdeep";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
