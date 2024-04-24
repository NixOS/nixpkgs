{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, numpy
, scipy
, pandas
, matplotlib
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "seasonal";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "welch";
    repo = "seasonal";
    # There are no tags or releases, but this commit corresponds to the 0.3.1 version
    # PyPI project contains only a wheel
    rev = "2a2396014d46283d0c7aff34cde5dafb6c462c58";
    hash = "sha256-8YedGylH70pI0OyefiS1PG1yc+sg+tchlgcuNvxcNqE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'setup_requires=["pytest-runner"],' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  passthru.optional-dependencies = {
    csv = [
      pandas
    ];
    plot = [
      matplotlib
    ];
  };

  pythonImportsCheck = [ "seasonal" "seasonal.trend" "seasonal.periodogram" ];
  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  meta = with lib; {
    description = "Robustly estimate trend and periodicity in a timeseries";
    homepage = "https://github.com/welch/seasonal";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
