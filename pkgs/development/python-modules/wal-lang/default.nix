{ lib
, fetchFromGitHub
, buildPythonPackage
, pip
, importlib-resources
, lark-parser
, pylibfst
}:
buildPythonPackage {
  pname = "wal-lang";
  version = "unstable-2023-08-12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ics-jku";
    repo = "wal";
    rev = "06498c3f5341ce687a37ad52647f300b72dff52a";
    hash = "sha256-gdgaqpbWtc66FEwhTV0AI88TLyfUheBQo4AuZgNyTKY=";
  };

  nativeBuildInputs = [
    pip
  ];

  propagatedBuildInputs = [
    importlib-resources
    lark-parser
    pylibfst
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ics-jku/wal";
    description = "Programmable waveform analysis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ avimitin ];
  };
}
