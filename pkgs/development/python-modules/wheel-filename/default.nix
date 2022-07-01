{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wheel-filename";
  version = "1.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M3XGHG733X5qKuMS6mvFSFHYOwWPaBMXw+w0eYo6ByE=";
  };

  buildInputs = [
    attrs
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov=wheel_filename --no-cov-on-fail" ""
  '';

  pythonImportsCheck = [
    "wheel_filename"
  ];

  meta = with lib; {
    description = "Parse wheel filenames";
    homepage = "https://github.com/jwodder/wheel-filename";
    license = with licenses; [ mit ];
    maintainers = with lib.maintainers; [ ayazhafiz ];
  };
}
