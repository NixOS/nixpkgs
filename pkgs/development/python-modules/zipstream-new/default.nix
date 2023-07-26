{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
}:

buildPythonPackage rec {
  pname = "zipstream-new";
  version = "1.1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "arjan-s";
    repo = "python-zipstream";
    rev = "v${version}";
    sha256 = "14vhgg8mcjqi8cpzrw8qzbij2fr2a63l2a8fhil21k2r8vzv92cv";
  };

  pythonImportsCheck = [
    "zipstream"
  ];

  nativeCheckInputs = [
    nose
  ];

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  meta = with lib; {
    description = "Like Python's ZipFile module, except it works as a generator that provides the file in many small chunks";
    homepage = "https://github.com/arjan-s/python-zipstream";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hexa ];
  };
}
