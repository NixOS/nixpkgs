{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, isPy27 }:

buildPythonPackage rec {
  pname = "unicodedata2";
  version = "15.0.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit version pname;
    sha256 = "0bcgls7m2zndpd8whgznnd5908jbsa50si2bh88wsn0agcznhv7d";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Backport and updates for the unicodedata module";
    homepage = "https://github.com/mikekap/unicodedata2";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
