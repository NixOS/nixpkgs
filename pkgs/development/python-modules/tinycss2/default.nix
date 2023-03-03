{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, webencodings
, pytestCheckHook
, flit-core
}:

buildPythonPackage rec {
  pname = "tinycss2";
  version = "1.1.1";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kozea";
    repo = "tinycss2";
    rev = "v${version}";
    # for tests
    fetchSubmodules = true;
    hash = "sha256-RUF/3cjNgDFofoxl9iKY3u5ZAVVQmXu2Qbb5U4brdcQ=";
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
