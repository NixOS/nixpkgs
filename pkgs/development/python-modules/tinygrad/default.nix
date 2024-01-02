{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "tinygrad";
  version = "0.7.0";
  pyproject = true;
  
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tinygrad";
    repo = "tinygrad";
    rev = "v${version}";
    hash = "sha256-lXpMqG8yNYkYZ0LZh5ERYCViELTauwiijDRAmQZIfQI=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "tinygrad" ];

  meta = with lib; {
    description = "You like pytorch? You like micrograd? You love tinygrad";
    homepage = "https://github.com/tinygrad/tinygrad";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
