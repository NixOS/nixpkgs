{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
# build inputs
, typing-extensions
}:

buildPythonPackage rec {
  pname = "widlparser";
  version = "1.0.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "plinss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-T17fDWYd1naza/ao7kXWGcRIl2fzL1/Z9SaJiutZzqk=";
  };

  postPatch = ''
    sed -i -e 's/0.0.0/${version}/' setup.py
  '';

  propagatedBuildInputs = [
    typing-extensions
  ];

  pythonImportsCheck = [ "widlparser" ];

  meta = with lib; {
    description = "Stand-alone WebIDL Parser in Python";
    homepage = "https://github.com/plinss/widlparser";
    license = licenses.mit;
    maintainers = [];
  };
}
