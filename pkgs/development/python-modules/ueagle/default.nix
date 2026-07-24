{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "ueagle";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jcalbert";
    repo = "uEagle";
    rev = version;
    sha256 = "1hxwk5alalvmhc31y917dxsnbiwq1xci2krma3235581319xr3w7";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "uEagle" ];

  meta = {
    description = "Python library Rainforest EAGLE devices";
    homepage = "https://github.com/jcalbert/uEagle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
