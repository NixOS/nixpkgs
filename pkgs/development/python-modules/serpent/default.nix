{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  enum34,
  attrs,
  pytz,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "serpent";
  version = "1.41";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BAcDX+PGZEOH1Iz/FGfVqp/v+BTQc3K3hnftDuPtcJU=";
  };

  propagatedBuildInputs = lib.optionals isPy27 [ enum34 ];

  nativeCheckInputs = [
    attrs
    pytz
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple serialization library based on ast.literal_eval";
    homepage = "https://github.com/irmen/Serpent";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
