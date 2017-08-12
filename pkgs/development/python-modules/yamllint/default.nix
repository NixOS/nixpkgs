{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "0.5.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0brdy1crhfng10hlw0420bv10c2xnjk8ndnhssybkzym47yrzg84";
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
