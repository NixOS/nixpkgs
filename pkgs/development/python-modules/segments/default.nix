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
  version = "2.2.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = pname;
    rev = "v${version}";
    sha256 = "04yc8q79zk09xj0wnal0vdg5azi9jlarfmf2iyljqyr80p79gwvv";
  };

  patchPhase = ''
    substituteInPlace setup.cfg --replace "--cov" ""
  '';

  propagatedBuildInputs = [
    regex
    csvw
    clldutils
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    description = "Unicode Standard tokenization routines and orthography profile segmentation";
    homepage = "https://github.com/cldf/segments";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
