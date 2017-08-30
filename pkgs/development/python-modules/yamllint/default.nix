{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.8.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "048743567ca9511e19222233ebb53795586a2cede07b79e801577e0a9b4f173c";
  };

  buildInputs = [ nose ];

  propagatedBuildInputs = [  pyyaml ];

  meta = with stdenv.lib; {
    description = "A linter for YAML files";
    homepage = https://github.com/adrienverge/yamllint;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mikefaille ];
  };
}
