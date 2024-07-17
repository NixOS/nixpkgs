{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  webencodings,
  pytestCheckHook,
  flit-core,
}:

buildPythonPackage rec {
  pname = "tinycss2";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kozea";
    repo = "tinycss2";

    # Tag v1.3.0 is missing the actual version number bump.
    rev = "bda62b101530588718d931d61bcc343a628b9af9";
    # for tests
    fetchSubmodules = true;
    hash = "sha256-Exjxdm0VnnjHUKjquXsC/zDmwA7bELHdX1f55IGBjYk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "'pytest-cov', 'pytest-flake8', 'pytest-isort', 'coverage[toml]'" "" \
      --replace "--isort --flake8 --cov --no-cov-on-fail" ""
  '';

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ webencodings ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Low-level CSS parser for Python";
    homepage = "https://github.com/Kozea/tinycss2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
