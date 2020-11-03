{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, regex
, csvw
, clldutils
, mock
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "segments";
  version = "2.1.3";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = pname;
    rev = "v${version}";
    sha256 = "12lnpk834r3y7hw5x7nvswa60ddh69ylvr44k46gqcfba160hhb0";
  };

  patchPhase = ''
    substituteInPlace setup.cfg --replace "--cov" ""
  '';

  requiredPythonModules = [
    regex
    csvw
    clldutils
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    description = "Unicode Standard tokenization routines and orthography profile segmentation";
    homepage = "https://github.com/cldf/segments";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
