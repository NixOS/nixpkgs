{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, mecab
, setuptools-scm
, requests
, tqdm
, wasabi
, plac
, cython
, platformdirs
}:

buildPythonPackage rec {
  pname = "unidic";
  version = "1.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "polm";
    repo = "unidic-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-srhQDXGgoIMhYuCbyQB3kF4LrODnoOqLbjBQMvhPieY=";
  };

  patches = [ ./fix-download-directory.patch ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "wasabi>=0.6.0,<1.0.0" "wasabi"
  '';

  # no tests
  doCheck = false;

  propagatedBuildInputs = [ requests tqdm wasabi plac platformdirs ];

  nativeBuildInputs = [ cython mecab setuptools-scm ];

  pythonImportsCheck = [ "unidic" ];

  meta = with lib; {
    description = "Contemporary Written Japanese dictionary";
    homepage = "https://github.com/polm/unidic-py";
    license = licenses.mit;
    maintainers = with maintainers; [ laurent-f1z1 ];
  };
}
