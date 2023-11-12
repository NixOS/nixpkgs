{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, isPy27 }:

buildPythonPackage rec {
  pname = "unicodedata2";
  version = "15.1.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-yzDxia1mSC+FKaRdpxsqiEHpvSuzdswpMwA6SlWgdkg=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Backport and updates for the unicodedata module";
    homepage = "https://github.com/mikekap/unicodedata2";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
