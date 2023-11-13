{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinxHook
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-prompt";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "sbrunner";
    repo = "sphinx-prompt";
    rev = version;
    hash = "sha256-ClUPAIyPrROJw4GXeakA8U443Vlhy3P/2vFnAtyrPHU=";
  };

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    description = "A sphinx extension for creating unselectable prompt";
    homepage = "https://github.com/sbrunner/sphinx-prompt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
