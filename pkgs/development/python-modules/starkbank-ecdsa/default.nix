{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "starkbank-ecdsa";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "starkbank";
    repo = "ecdsa-python";
    rev = "v${version}";
    sha256 = "03smk33zhmv1j1svgjnykak0jnw8yl0yv03i1gsasx71f33zmfwi";
  };

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "-v tests/*.py" ];
  pythonImportsCheck = [ "ellipticcurve" ];

  meta = with lib; {
    description = "Python ECDSA library";
    homepage = "https://github.com/starkbank/ecdsa-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
