{ lib
, buildPythonPackage
, fetchFromGitHub
, h3
, numba
, numpy
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "timezonefinder";
  version = "6.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jannikmi";
    repo = pname;
    rev = version;
    hash = "sha256-jquaA/+alSRUaa2wXQ6YoDR4EY9OlZCAdcxS5TR0CAU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    h3
    numpy
  ];

  checkInputs = [
    numba
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'numpy = "^1.22"' 'numpy = "*"'
  '';

  pythonImportsCheck = [
    "timezonefinder"
  ];

  preCheck = ''
    # Some tests need the CLI on the PATH
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "Module for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
