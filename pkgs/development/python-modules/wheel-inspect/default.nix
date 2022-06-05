{ lib
, attrs
, buildPythonPackage
, entry-points-txt
, fetchFromGitHub
, headerparser
, jsonschema
, packaging
, pytestCheckHook
, pythonOlder
, readme_renderer
, wheel-filename
}:

buildPythonPackage rec {
  pname = "wheel-inspect";
  version = "1.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pB9Rh+A7GlxnYuka2mTSBoxpoyYCzoaMPVgsHDlpos0=";
  };

  propagatedBuildInputs = [
    attrs
    entry-points-txt
    headerparser
    packaging
    readme_renderer
    wheel-filename
  ];

  checkInputs = [
    jsonschema
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov=wheel_inspect --no-cov-on-fail" ""
  '';

  pythonImportsCheck = [
    "wheel_inspect"
  ];

  meta = with lib; {
    description = "Extract information from wheels";
    homepage = "https://github.com/jwodder/wheel-inspect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ayazhafiz ];
  };
}
