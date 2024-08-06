{ buildPythonPackage
, fetchFromGitHub
, pythonOlder
, lib
}:

buildPythonPackage rec {
  pname = "smoke-zephyr";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "zeroSteiner";
    repo = "smoke-zephyr";
    rev = "v${version}";
    hash = "sha256-XZj8sxEWYv5z1x7LKb0T3L7MWSZbWr7lAIyjWekN+WY=";
  };

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "smoke_zephyr" ];

  meta = with lib; {
    homepage = "https://github.com/zeroSteiner/smoke-zephyr";
    description = "A collection of miscellaneous Python utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ t4ccer ];
  };
}
