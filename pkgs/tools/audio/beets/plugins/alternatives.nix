{ lib, fetchFromGitHub, beets, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "beets-alternatives";
  version = "0.10.2";

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    rev = "v${version}";
    sha256 = "1dsz94fb29wra1f9580w20bz2f1bgkj4xnsjgwgbv14flbfw4bp0";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "addopts = --cov --cov-report=term --cov-report=html" ""
  '';

  nativeBuildInputs = [ beets ];

  checkInputs = with pythonPackages; [
    pytestCheckHook
    mock
  ];

  meta = {
    description = "Beets plugin to manage external files";
    homepage = "https://github.com/geigerzaehler/beets-alternatives";
    maintainers = [ lib.maintainers.aszlig ];
    license = lib.licenses.mit;
  };
}
