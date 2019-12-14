{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "simpleeval";
  version = "0.9.10";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1skvl467kj83rzkhk01i0wm8m5vmh6j5znrfdizn6r18ii45a839";
  };
  meta = {
    homepage = https://github.com/danthedeckie/simpleeval;
    description = "A simple, safe single expression evaluator library";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
