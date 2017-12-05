{ stdenv, lib, buildPythonApplication, fetchPypi, pyyaml, jq }:

buildPythonApplication rec {

  name = "${pname}-${version}";
  pname = "yq";
  version = "2.3.3";

  propagatedBuildInputs = [ pyyaml jq ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "14ywdi464z68qclsqzb8r50rzmypknaz74zmpppkahjigfcfppm3";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = https://pypi.python.org/pypi/yq;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };

}
