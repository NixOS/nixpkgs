{ stdenv, lib, buildPythonApplication, fetchPypi, pyyaml, jq }:

buildPythonApplication rec {

  pname = "yq";
  version = "2.3.4";

  propagatedBuildInputs = [ pyyaml jq ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04ckrlmin8m176iicyfhddp4r0yry5hx306vhfglf8mcp1jkga78";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = https://pypi.python.org/pypi/yq;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };

}
