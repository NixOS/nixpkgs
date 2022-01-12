{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, webencodings
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tinycss2";
  version = "1.1.0";
  disabled = pythonOlder "3.5";
  format = "flit";

  src = fetchFromGitHub {
    owner = "kozea";
    repo = "tinycss2";
    rev = "v${version}";
    # for tests
    fetchSubmodules = true;
    sha256 = "sha256-WA88EYolL76WqeA1UKR3Sfw11j8NuOGOxPezujYizH8=";
  };

  propagatedBuildInputs = [ webencodings ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "'pytest-cov', 'pytest-flake8', 'pytest-isort', 'coverage[toml]'" "" \
      --replace "--isort --flake8 --cov" ""
  '';

  meta = with lib; {
    description = "Low-level CSS parser for Python";
    homepage = "https://github.com/Kozea/tinycss2";
    license = licenses.bsd3;
  };
}
