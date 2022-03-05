{ lib
, fetchFromGitHub
, buildPythonPackage
, importlib-metadata
, ipython
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "watermark";
  version = "2.3.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kl9yn1pkl84d3lcz7bvphqkydsgs0p5k0ja0msy3hrxxfzdzd16";
  };

  propagatedBuildInputs = [
    ipython
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  checkInputs =  [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "watermark" ];

  meta = with lib; {
    description = "IPython extension for printing date and time stamps, version numbers, and hardware information.";
    homepage = "https://github.com/rasbt/watermark";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nphilou ];
  };
}
