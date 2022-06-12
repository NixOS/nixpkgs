{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, isPy27 }:

buildPythonPackage rec {
  pname = "unicodedata2";
  version = "14.0.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit version pname;
    sha256 = "110nnvh02ssp92xbmswy39aa186jrmb7m41x4220wigl8c0dzxs1";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Backport and updates for the unicodedata module";
    homepage = "https://github.com/mikekap/unicodedata2";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
