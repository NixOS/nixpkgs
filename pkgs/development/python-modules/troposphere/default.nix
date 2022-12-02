{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python

  # python dependencies
, awacs
, cfn-flip
, typing-extensions
}:

buildPythonPackage rec {
  pname = "troposphere";
  version = "4.1.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cloudtools";
    repo = pname;
    rev = version;
    hash = "sha256-cAn4Hty5f/RsCnUA59CxtGrhRgzVyaHe5PuQOM6lwEQ=";
  };

  propagatedBuildInputs = [
    cfn-flip
  ] ++ lib.lists.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    awacs
  ];

  passthru.optional-dependencies = {
    policy = [ awacs ];
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [ "troposphere" ];

  meta = with lib; {
    description = "Library to create AWS CloudFormation descriptions";
    maintainers = with maintainers; [ jlesquembre ];
    license = licenses.bsd2;
    homepage = "https://github.com/cloudtools/troposphere";
  };
}
