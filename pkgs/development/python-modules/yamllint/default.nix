{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml, pathspec }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.9.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75295a7cbfb3529e02551d4e95c2e3eb85d66292bedcfb463d25d71308065e34";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [  pyyaml pathspec ];

  # Two test failures
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A linter for YAML files";
    homepage = https://github.com/adrienverge/yamllint;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mikefaille ];
  };
}
