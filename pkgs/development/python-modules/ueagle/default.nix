{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "ueagle";
  version = "0.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jcalbert";
    repo = "uEagle";
    rev = version;
    sha256 = "1hxwk5alalvmhc31y917dxsnbiwq1xci2krma3235581319xr3w7";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "uEagle" ];

  meta = with lib; {
    description = "Python library Rainforest EAGLE devices";
    homepage = "https://github.com/jcalbert/uEagle";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
